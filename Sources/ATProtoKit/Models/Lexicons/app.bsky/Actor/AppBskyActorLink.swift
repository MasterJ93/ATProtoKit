//
//  AppBskyActorLink.swift
//
//
//  Created by Scott Handley on 2026-10-11.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AppBskyLexicon.Actor {
    
    /// The data model definition for a link.
    ///
    /// - Note: According to the AT Protocol specifications: "A link shown on the account's
    /// profile. The profile record's links field sets which links are shown, and in what order."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.actor.link`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/link.json
    public struct LinkRecord: ATRecordProtocol, Sendable {
        
        /// The identifier of the lexicon.
        ///
        /// - Warning: The value must not change.
        public static let type: String = "app.bsky.actor.link"
        
        /// The link destination, an https URL.
        public let url: String
        
        /// Label for the link. Clients can fall back to the destination's domain. Optional.
        public let title: String?
        
        /// The destination site's icon, uploaded when the link is saved."
        public let iconBlob: ComAtprotoLexicon.Repository.UploadBlobOutput?
        
        /// The date and time the link was created. Optional.
        public let createdAt: Date
        
        public init(url: String, title: String?, iconBlob: ComAtprotoLexicon.Repository.UploadBlobOutput?, createdAt: Date) {
            self.url = url
            self.title = title
            self.iconBlob = iconBlob
            self.createdAt = createdAt
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.url = try container.decode(String.self, forKey: .url)
            self.title = try container.decodeIfPresent(String.self, forKey: .title)
            self.iconBlob = try container.decodeIfPresent(ComAtprotoLexicon.Repository.UploadBlobOutput.self, forKey: .iconBlob)
            self.createdAt = try container.decodeDate(forKey: .createdAt)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(Self.type, forKey: .type)
            
            try container.encode(self.url, forKey: .url)
            try container.truncatedEncodeIfPresent(self.title, forKey: .title, upToCharacterLength: 320)
            try container.encodeIfPresent(self.iconBlob, forKey: .iconBlob)
            try container.encodeDate(self.createdAt, forKey: .createdAt)
        }
        
        enum CodingKeys: String, CodingKey {
            case type = "$type"
            case url
            case title
            case iconBlob = "icon"
            case createdAt
        }
    }
}
