//
//  CreatePostRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

extension ATProtoBluesky {

    /// Creates a post record to the user's account.
    /// 
    /// - Parameters:
    ///   - text: The text that's directly displayed in the post record. Current limit is
    ///   300 characters.
    ///   - locales: The languages the text is written in. Current limit is 3 languages.
    ///   - replyTo: The post record that this record is replying to.
    ///   - embed: The embed container attached to the post record. Current items include
    ///   images, external links, other posts, lists, and post records with media.
    ///   - labels: An array of labels made by the user.
    ///   - tags: An array of tags for the post record.
    ///   - creationDate: The date of the post record. Defaults to `Date.now`.
    ///   - recordKey: The record key of the collection. Optional.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createPostRecord(
        text: String,
        locales: [Locale] = [],
        replyTo: String? = nil,
        embed: EmbedIdentifier? = nil,
        labels: ATUnion.PostSelfLabelsUnion? = nil,
        tags: [String]? = nil,
        creationDate: Date = Date(),
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {

        guard let session else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL else {
            throw ATRequestPrepareError.invalidPDS
        }
        // Replies
        var resolvedReplyTo: AppBskyLexicon.Feed.PostRecord.ReplyReference? = nil
        if let replyURI = replyTo {
            do {
                resolvedReplyTo = try await ATProtoTools().resolveReplyReferences(parentURI: replyURI)
            } catch {
                throw error
            }
        }

        // Locales
        let localeIdentifiers = locales.isEmpty ? nil : locales.map { $0.identifier }

        // Embed
        var resolvedEmbed: ATUnion.PostEmbedUnion? = nil
        if let embedUnion = embed {
            do {
                switch embedUnion {
                    case .images(let images):
                        resolvedEmbed = try await uploadImages(images, pdsURL: sessionURL, accessToken: session.accessToken)
                    case .external(let external):
                        resolvedEmbed = try await buildExternalEmbed(from: external)
                    case .record(let record):
                        resolvedEmbed = try await addQuotePostToEmbed(record)
                    case .recordWithMedia(let recordWithMedia):
//                        resolvedEmbed = .recordWithMedia(recordWithMedia)
                        break
                }
            } catch {
                throw error
            }
        }

        // Compiling all parts of the post into one.
        let postRecord = AppBskyLexicon.Feed.PostRecord(
            text: text,
            facets: await ATFacetParser.parseFacets(from: text, pdsURL: session.accessToken),
            reply: resolvedReplyTo,
            embed: resolvedEmbed,
            languages: localeIdentifiers,
            labels: labels,
            tags: tags,
            createdAt: creationDate
        )

        return try await atProtoKitInstance.createRecord(
            repositoryDID: session.sessionDID,
            collection: "app.bsky.feed.post",
            recordKey: recordKey ?? nil,
            shouldValidate: shouldValidate,
            record: UnknownType.record(postRecord),
            swapCommit: swapCommit ?? nil
        )
    }
    
    /// Uploads images to the AT Protocol for attaching to a record at a later request.
    /// - Parameters:
    ///   - images: The ``ComAtprotoLexicon/Repository/ImageQuery`` that contains the image data. Current limit is 4 images.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    ///   - accessToken: The access token used to authenticate to the user.
    /// - Returns: An ``ATUnion/EmbedViewUnion``, which contains an array of ``AppBskyLexicon/Embed/ImagesDefinition``s for
    /// use in a record.
    ///
    /// - Important: Each image can only be 1 MB in size.
    public func uploadImages(_ images: [ComAtprotoLexicon.Repository.ImageQuery], pdsURL: String = "https://bsky.social",
                             accessToken: String) async throws -> ATUnion.PostEmbedUnion {
        var embedImages = [AppBskyLexicon.Embed.ImagesDefinition.Image]()

        for image in images {
            // Check if the image is too large.
            guard image.imageData.count <= 1_000_000 else {
                throw ATBlueskyError.imageTooLarge
            }

            // Upload the image, then get the server response.
            let blobReference = try await APIClientService.shared.uploadBlob(pdsURL: pdsURL, accessToken: accessToken, filename: image.fileName,
                                                                             imageData: image.imageData)

            let embedImage = AppBskyLexicon.Embed.ImagesDefinition.Image(image: blobReference.blob, altText: image.altText ?? "", aspectRatio: nil)
            embedImages.append(embedImage)
        }

        return .images(AppBskyLexicon.Embed.ImagesDefinition(images: embedImages))
    }
    
    /// Scraps the website for the required information in order to attach to a record's embed at a
    /// later request.
    /// - Parameter url: The URL of the website
    /// - Returns: An ``ATUnion/EmbedViewUnion`` which contains an ``AppBskyLexicon/Embed/ExternalDefinition`` for use
    /// in a record.
    public func buildExternalEmbed(from url: URL) async throws -> ATUnion.PostEmbedUnion? {

        // Temporary comment until it's time to work on this part of the library.
//        let external = EmbedExternal(external: External(embedURI: "", title: "", description: "", thumbnailImage: UploadBlobOutput(type: <#T##String?#>, reference: <#T##BlobReference#>, mimeType: <#T##String#>, size: <#T##Int#>)))
//        return .external(external)
        return nil
    }

    /// Grabs and validates a post record to attach to a record's embed at a later request.
    /// - Parameter strongReference: An object that contains the record's `recordURI` (URI) and
    /// the `cidHash` (CID) .
    /// - Returns: A strong reference, which contains a record's `recordURI` (URI) and the
    /// `cidHash` (CID) .
    public func addQuotePostToEmbed(_ strongReference: ComAtprotoLexicon.Repository.StrongReference) async throws -> ATUnion.PostEmbedUnion {
        let record = try await ATProtoTools().fetchRecordForURI(strongReference.recordURI)
        let reference = ComAtprotoLexicon.Repository.StrongReference(recordURI: record.recordURI, cidHash: record.recordCID)
        let embedRecord = AppBskyLexicon.Embed.RecordDefinition(record: reference)

        return .record(embedRecord)
    }

    enum UploadError: Error {
        case badServerResponse
        case cannotParseResponse
    }
    
    /// Represents the different types of content that can be embedded in a post record.
    ///
    /// `EmbedIdentifier` provides a unified interface for specifying embeddable content,
    /// simplifying the process of attaching images, external links, other post records, or media
    /// to a post. By abstracting the details of each embed type, it allows methods like
    /// ``createPostRecord(text:locales:replyTo:embed:labels:tags:creationDate:recordKey:shouldValidate:swapCommit:)``
    /// to handle the necessary operations (e.g., uploading, grabbing metadata, validation, etc.)
    /// behind the scenes, streamlining the embedding process.
    public enum EmbedIdentifier {

        /// Represents a set of images to be embedded in the post.
        /// - Parameter images: An array of `ImageQuery` objects, each containing the image data,
        /// metadata, and filenames of the image.
        case images(images: [ComAtprotoLexicon.Repository.ImageQuery])

        /// Represents an external link to be embedded in the post.
        /// - Parameter url: A `URL` pointing to the external content.
        case external(url: URL)

        /// Represents another post record that is to be embedded within the current post.
        /// - Parameter strongReference: A `StrongReference` to the post record to be embedded,
        /// which contains a record's `recordURI` (URI) and the `cidHash` (CID) .
        case record(strongReference: ComAtprotoLexicon.Repository.StrongReference)

        /// Represents a post record accompanied by media, to be embedded within the current post.
        /// - Parameters:
        ///   - record: An `EmbedRecord`, representing the post to be embedded.
        ///   - media: A `MediaUnion`, representing the media content associated with the post.
        case recordWithMedia(record: AppBskyLexicon.Embed.RecordDefinition, media: ATUnion.RecordWithMediaUnion)
    }
}
