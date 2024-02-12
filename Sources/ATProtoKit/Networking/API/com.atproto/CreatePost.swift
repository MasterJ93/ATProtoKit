//
//  CreatePost.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

extension ATProtoKit {
    /// Creates a post record to the user's account.
    /// - Parameters:
    ///   - text: The text that's directly displayed in the post record. Current limit is 300 characters.
    ///   - locales: The languages the text is written in. Current limit is 3 lanagues.
    ///   - replyTo: The post record that this record is replying to.
    ///   - embed: The embed container attached to the post record. Current items include images, external links, other posts, lists, and post records with media.
    ///   - labels: A list of labels made by the user.
    ///   - tags: A list of tags for the post record.
    ///   - creationDate: The date of the post record. Defaults to the current time of the post record's creation.
    /// - Returns: A strong reference, which contains the newly-created record's `recordURI` (URI) and the `cidHash` (CID) .
    public func createPostRecord(text: String, locales: [Locale] = [], replyTo: String? = nil, embed: EmbedIdentifier? = nil, labels: FeedLabelUnion? = nil, tags: [String]? = nil, creationDate: Date = Date.now) async -> Result<StrongReference, Error> {

        guard let sessionURL = session.pdsURL else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid pdsURL"]))
        }
        // Replies
        var resolvedReplyTo: ReplyReference? = nil
        if let replyURI = replyTo {
            do {
                resolvedReplyTo = try await ATProtoKit.resolveReplyReferences(parentURI: replyURI)
            } catch {
                return .failure(error)
            }
        }

        // Locales
        let localeIdentifiers = locales.isEmpty ? nil : locales.map { $0.identifier }

        // Embed
        var resolvedEmbed: EmbedUnion? = nil
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
                return .failure(error)
            }
        }

        // Labels
        var resolvedLabels: FeedLabelUnion? = nil


        // Tags
        var resolvedTags: [String]? = nil


        // Compiling all parts of the post into one.
        let post = FeedPost(
            text: text,
            facets: await ParseHelper.parseFacets(from: text, pdsURL: session.accessToken),
            reply: resolvedReplyTo,
            embed: resolvedEmbed,
            languages: localeIdentifiers,
            labels: labels,
            tags: tags,
            createdAt: creationDate)

        let requestBody = FeedPostRequestBody(
            repo: session.atDID,
            record: post
        )

        return await createRecord(collection: "app.bsky.feed.post", requestBody: requestBody)
    }
    
    /// Uploads images to the AT Protocol for attaching to a record at a later request.
    /// - Parameters:
    ///   - images: The ``ImageQuery`` that contains the image data. Current limit is 4 images.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///   - accessToken: The access token used to authenticate to the user.
    /// - Returns: An ``EmbedUnion``, which contains a list of ``EmbedImage``s for use in a record.
    ///
    /// - Important: Each image can only be 1 MB in size.
    public func uploadImages(_ images: [ImageQuery], pdsURL: String = "https://bsky.social", accessToken: String) async throws -> EmbedUnion {
        var embedImages = [EmbedImage]()

        for image in images {
            // Check if the image is too large.
            guard image.imageData.count <= 1_000_000 else {
                throw NSError(domain: "ATProtoKit", code: -2, userInfo: [NSLocalizedDescriptionKey: "Image file size too large. 1,000,000 bytes maximum."])
            }

            // Upload the image, then get the server response.
            let blobReference = try await APIClientService.uploadBlob(pdsURL: pdsURL, accessToken: accessToken, filename: image.fileName, imageData: image.imageData)

            let embedImage = EmbedImage(image: blobReference.blob, altText: image.altText ?? "", aspectRatio: nil)
            embedImages.append(embedImage)
        }

        return .images(EmbedImages(images: embedImages))
    }
    
    /// Scraps the website for the required information in order to attach to a record's embed at a later request.
    /// - Parameter url: The URL of the website
    /// - Returns: An ``EmbedUnion`` which contains an ``EmbedExternal`` for use in a record.
    public func buildExternalEmbed(from url: URL) async throws -> EmbedUnion {
        
        let external = EmbedExternal(external: External(embedURI: "", title: "", description: "", thumbnail: Data(count: 1)))
        return .external(external)
    }

    /// Grabs and validates a post record to attach to a record's embed at a later request.
    /// - Parameter strongReference: An object that contains the record's `recordURI` (URI) and the `cidHash` (CID) .
    /// - Returns: A strong reference, which contains a record's `recordURI` (URI) and the `cidHash` (CID) .
    public func addQuotePostToEmbed(_ strongReference: StrongReference) async throws -> EmbedUnion {
        let record = try await ATProtoKit.fetchRecordForURI(strongReference.recordURI)
        let reference = StrongReference(recordURI: record.atURI, cidHash: record.recordCID)
        let embedRecord = EmbedRecord(record: reference)

        return .record(embedRecord)
    }

    struct FeedPostRequestBody: Encodable {
        let repo: String
        let collection: String = "app.bsky.feed.post"
        let record: FeedPost
    }

    enum UploadError: Error {
        case badServerResponse
        case cannotParseResponse
    }
    
    /// Represents the different types of content that can be embedded in a post record.
    ///
    /// `EmbedIdentifier` provides a unified interface for specifying embeddable content, simplifying the process of attaching
    /// images, external links, other post records, or media to a post. By abstracting the details of each embed type, it allows methods
    /// like ``createPostRecord(text:locales:replyTo:embed:labels:tags:creationDate:)`` to handle the
    /// necessary operations (e.g., uploading, grabbing metadata, validation, etc.) behind the scenes, streamlining the embedding process.
    public enum EmbedIdentifier {
        /// Represents a set of images to be embedded in the post.
        /// - Parameter images: An array of `ImageQuery` objects, each containing the image data, metadata, and filenames of the image.
        case images(images: [ImageQuery])
        /// Represents an external link to be embedded in the post.
        /// - Parameter url: A `URL` pointing to the external content.
        case external(url: URL)
        /// Represents another post record that is to be embedded within the current post.
        /// - Parameter strongReference: A `StrongReference` to the post record to be embedded, which contains a record's `recordURI` (URI) and the `cidHash` (CID) .
        case record(strongReference: StrongReference)
        /// Represents a post record accompanied by media, to be embedded within the current post.
        /// - Parameters:
        ///   - record: An `EmbedRecord`, representing the post to be embedded.
        ///   - media: A `MediaUnion`, representing the media content associated with the post.
        case recordWithMedia(record: EmbedRecord, media: MediaUnion)
    }
}
