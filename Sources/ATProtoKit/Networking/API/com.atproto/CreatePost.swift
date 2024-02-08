//
//  CreatePost.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

extension ATProtoKit {
    public func createPost(text: String, locales: [Locale] = [], replyTo: String? = nil, embed: EmbedConfiguration? = nil, labels: FeedLabelUnion? = nil, tags: [String]? = nil, creationDate: Date = Date.now) async -> Result<StrongReference, Error> {
        // This is required, or else the guard statement will fail
        guard let sessionURL = session.pdsURL,
              let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
            return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
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
            record: post)

        let request = APIClientService.createRequest(forRequest: requestURL, andMethod: .post, authorizationValue: "Bearer \(session.accessToken)")

        do {
            let result = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: StrongReference.self)

            return .success(result)
        } catch {
            return .failure(error)
        }
    }

    public func uploadImages(_ images: [ImageQuery], pdsURL: String = "https://bsky.social", accessToken: String) async throws -> EmbedUnion {
        var embedImages = [EmbedImage]()

        for image in images {
            // Check if the image is too large.
            guard image.imageData.count <= 1_000_000 else {
                throw NSError(domain: "ATProtoKit", code: -2, userInfo: [NSLocalizedDescriptionKey: "Image file size too large. 1,000,000 bytes maximum."])
            }

            // Upload the image, then get the server response.
            let blobReference = try await APIClientService.uploadBlob(pdsURL: pdsURL, accessToken: accessToken, filename: image.fileName, imageData: image.imageData)

            let embedImage = EmbedImage(image: blobReference, altText: image.altText ?? "", aspectRatio: nil)
            embedImages.append(embedImage)
        }

        return .images(EmbedImages(images: embedImages))
    }

    public func buildExternalEmbed(from url: URL) async throws -> EmbedUnion {
        
        let external = EmbedExternal(external: External(embedURI: "", title: "", description: "", thumbnail: Data(count: 1)))
        return .external(external)
    }

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

    public enum EmbedConfiguration {
        case images(images: [ImageQuery])
        case external(url: URL)
        case record(strongReference: StrongReference)
        case recordWithMedia(record: EmbedRecord, media: MediaUnion)
    }
}
