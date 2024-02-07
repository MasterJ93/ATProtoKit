//
//  CreatePost.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

extension ATProtoKit {
    public func createPost(text: String, locales: [Locale] = [], replyTo: String? = nil, embed: EmbedUnion? = nil, labels: FeedLabelUnion? = nil, tags: [String]? = nil, creationDate: Date = Date.now) async -> Result<StrongReference, Error> {

        guard let pdsURL = session.pdsURL,
              let url = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.createRecord") else {
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
                        resolvedEmbed = .images(images)
                    case .external(let external):
                        resolvedEmbed = .external(external)
                    case .record(let record):
                        resolvedEmbed = .record(record)
                    case .recordWithMedia(let recordWithMedia):
                        resolvedEmbed = .recordWithMedia(recordWithMedia)
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
            facets: await ParseHelper.parseFacets(from: text, pdsURL: session.accessJwt),
            reply: resolvedReplyTo,
            embed: resolvedEmbed,
            languages: localeIdentifiers,
            labels: labels,
            tags: tags,
            createdAt: creationDate)

        let requestBody = FeedPostRequestBody(
            repo: session.did,
            record: post)

        let request = APIClientService.createRequest(forRequest: url, andMethod: .post, authorizationValue: "Bearer \(session.accessJwt)")

        do {
            let result = try await APIClientService.sendRequest(request, withEncodingBody: requestBody, decodeTo: StrongReference.self)

            return .success(result)
        } catch {
            return .failure(error)
        }
    }

    public func uploadFile(_ filename: String, writtenInBytes imageData: Data) async throws -> UploadBlobOutput {
        guard let pdsURL = session.pdsURL,
              let url = URL(string: "\(pdsURL)/xrpc/com.atproto.repo.uploadBlob") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        // Determine MIME type
        let mimeType: String
        switch filename.split(separator: ".").last?.lowercased() {
            case "png":
                mimeType = "image/png"
            case "jpeg", "jpg":
                mimeType = "image/jpeg"
            case "webp":
                mimeType = "image/webp"
            default:
                mimeType = "application/octet-stream"
        }

        do {
            var request = APIClientService.createRequest(forRequest: url, andMethod: .post, contentTypeValue: mimeType, authorizationValue: "Bearer \(mimeType)")

            let response = try await APIClientService.sendBinaryRequest(request, binaryData: imageData, decodeTo: UploadBlobOutput.self)

            return response
        } catch {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])
        }
    }

    static func uploadImages(_ images: [ImageQuery], pdsURL: URL, accessToken: String) async throws -> EmbedUnion {

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

    public func addQuotePostToEmbed(_ uri: String) async throws -> EmbedUnion {
        let record = try await ATProtoKit.fetchRecordForURI(uri)
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
}
