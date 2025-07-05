//
//  ComAtprotoRepoUploadBlob.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Repository {

    /// A request body model for uploading a blob.
    ///
    /// - Note: According to the AT Protocol specifications: "Upload a new blob, to be referenced
    /// from a repository record. The blob will be deleted if it is not referenced within a time
    /// window (eg, minutes). Blob restrictions (mimetype, size, etc) are enforced when the
    /// reference is created. Requires auth, implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.repo.uploadBlob`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/uploadBlob.json
    public struct UploadBlobRequestBody: Sendable, Codable {}

    // MARK: -
    // TODO: Find a way to remove BlobContainer without breaking the JSON encoding.
    // This will be here until a way to remove this without the issues of
    // the JSON encoding are solved.
    /// The container used for storing blobs within a record.
    ///
    /// - Note: This is a temporary measure and will be deleted once a better solution is made.
    public struct BlobContainer: Sendable, Codable, Equatable, Hashable {

        /// The blob itself.
        public let blob: UploadBlobOutput
    }

    /// A data model for a definition of an output of uploading a blob.
    public struct UploadBlobOutput: Sendable, Codable, Equatable, Hashable {

        /// The type of blob.
        public let type: String?

        /// The strong reference of the blob.
        public let reference: ComAtprotoLexicon.Repository.BlobReference

        /// The the MIME type.
        ///
        /// This can be a `.jpg`, `.png`, and `.gif`.
        public let mimeType: String

        /// The size of the blob.
        public let size: Int

        public init(type: String, reference: ComAtprotoLexicon.Repository.BlobReference, mimeType: String, size: Int) {
            self.type = type
            self.reference = reference
            self.mimeType = mimeType
            self.size = size
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.type = try? container.decodeIfPresent(String.self, forKey: .type)
            self.reference = try container.decode(ComAtprotoLexicon.Repository.BlobReference.self, forKey: .reference)
            self.mimeType = try container.decode(String.self, forKey: .mimeType)
            self.size = try container.decode(Int.self, forKey: .size)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(self.type, forKey: .type)
            try container.encode(self.reference, forKey: .reference)
            try container.encode(self.mimeType, forKey: .mimeType)
            try container.encode(self.size, forKey: .size)
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case reference = "ref"
            case mimeType
            case size
        }
    }

    /// A data model for a blob reference definition.
    public struct BlobReference: Sendable, Codable, Equatable, Hashable {

        /// The link of the blob reference.
        public let link: String
        
        public init(link: String) {
            self.link = link
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.link = try container.decode(String.self, forKey: .link)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.link, forKey: .link)
        }
        
        enum CodingKeys: String, CodingKey {
            case link = "$link"
        }
    }
}
