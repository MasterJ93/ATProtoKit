//
//  AppBskyUnspeccedGetTaggedSuggestions.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Unspecced {

    /// The main data model definition for the output of getting tagged suggestions.
    ///
    /// - Note: According to the AT Protocol specifications: "Get a list of suggestions (feeds
    /// and users) tagged with categories."
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getTaggedSuggestions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getTaggedSuggestions.json
    public struct GetTaggedSuggestionsOutput: Codable {

        /// An array of suggestions.
        public let suggestions: [TaggedSuggestion]
    }

    /// A data model for a tagged suggestion.
    ///
    /// - Important: This is an unspecced model, and as such, this is highly volatile and may
    /// change or be removed at any time. Use at your own risk.
    ///
    /// - SeeAlso: This is based on the [`app.bsky.unspecced.getTaggedSuggestions`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/unspecced/getTaggedSuggestions.json
    public struct TaggedSuggestion: Codable {

        /// The tag attached to the suggestion.
        public let tag: String

        /// Indicates whether the suggestion is a feed generator or actor (user).
        public let subjectType: SubjectType

        /// The URI of the suggestion.
        public let subjectURI: String

        public init(tag: String, subjectType: SubjectType, subjectURI: String) {
            self.tag = tag
            self.subjectType = subjectType
            self.subjectURI = subjectURI
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.tag = try container.decode(String.self, forKey: .tag)
            self.subjectType = try container.decode(TaggedSuggestion.SubjectType.self, forKey: .subjectType)
            self.subjectURI = try container.decode(String.self, forKey: .subjectURI)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.tag, forKey: .tag)
            try container.encode(self.subjectType, forKey: .subjectType)
            try container.encode(self.subjectURI, forKey: .subjectURI)
        }

        enum CodingKeys: String, CodingKey {
            case tag
            case subjectType
            case subjectURI = "subject"
        }

        // Enums
        /// Indicates whether the subject of the suggestion is a feed generator or an actor (user).
        public enum SubjectType: String, Codable {

            /// Indicates the subject of the suggestion is an actor (user).
            case actor

            /// Indicates the subject of the suggestion is a feed generator.
            case feed
        }
    }
}
