//
//  AppBskyAgeassuranceDefs.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-12-02.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// Please note: this is an incomplete version of the spec, and will be deleted in a future update.
// This is ONLY used in order to make sure the package is built successfully.
extension AppBskyLexicon.AgeAssurance {

    /// A definition model for the access level granted based on processed Age Assurance data.
    ///
    /// - Note: According to the AT Protocol specifications: "The access level granted based on Age
    /// Assurance data we've processed."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public enum AccessDefinition: String, Sendable, Codable {

        ///
        case unknown

        ///
        case none

        ///
        case safe

        ///
        case full
    }

    /// A definition model for the status of the Age Assurance process.
    ///
    /// - Note: According to the AT Protocol specifications: "The status of the Age Assurance process."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public enum StatusDefinition: String, Sendable, Codable {

        ///
        case unknown

        ///
        case pending

        ///
        case assured

        ///
        case blocked
    }

    /// A definition model for the user's computed Age Assurance state.
    ///
    /// - Note: According to the AT Protocol specifications: "The user's computed Age Assurance state."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct StateDefinition: Sendable, Codable {

        /// Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The timestamp when this state was
        /// last updated."
        public let lastInitiatedAt: Date?

        /// The status of the Age Assurance process.
        public let status: StatusDefinition

        /// The access level granted based on processed Age Assurance data.
        public let access: AccessDefinition
        
        public init(lastInitiatedAt: Date?, status: StatusDefinition, access: AccessDefinition) {
            self.lastInitiatedAt = lastInitiatedAt
            self.status = status
            self.access = access
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.lastInitiatedAt = try container.decodeDateIfPresent(forKey: .lastInitiatedAt)
            self.status = try container.decode(AppBskyLexicon.AgeAssurance.StatusDefinition.self, forKey: .status)
            self.access = try container.decode(AppBskyLexicon.AgeAssurance.AccessDefinition.self, forKey: .access)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: AppBskyLexicon.AgeAssurance.StateDefinition.CodingKeys.self)

            try container.encodeDateIfPresent(self.lastInitiatedAt, forKey: .lastInitiatedAt)
            try container.encode(self.status, forKey: .status)
            try container.encode(self.access, forKey: .access)
        }

        enum CodingKeys: CodingKey {
            case lastInitiatedAt
            case status
            case access
        }
    }

    /// A definition model for additional metadata required to compute Age Assurance state on the client.
    ///
    /// - Note: According to the AT Protocol specifications: "Additional metadata needed to compute Age
    /// Assurance state client-side."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct StateMetadataDefinition: Sendable, Codable {

        ///  Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "The account creation timestamp."
        public let accountCreatedAt: Date?

        public init(accountCreatedAt: Date?) {
            self.accountCreatedAt = accountCreatedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.accountCreatedAt = try container.decodeDateIfPresent(forKey: .accountCreatedAt)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeDateIfPresent(self.accountCreatedAt, forKey: .accountCreatedAt)
        }

        enum CodingKeys: CodingKey {
            case accountCreatedAt
        }
    }

    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: " "
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigDefinition: Sendable, Codable {

        ///
        ///
        /// - Note: According to the AT Protocol specifications: "The per-region Age
        /// Assurance configuration."
        public let regions: [AppBskyLexicon.AgeAssurance.ConfigRegionDefinition]
    }

    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: "The Age Assurance configuration for a specific region. "
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigRegionDefinition: Sendable, Codable {

        ///
        public let countryCode: String

        ///
        public let regionCode: String?

        ///
        public let rules: String
    }

    /// A definition model for the default age assurance rule.
    ///
    /// - Note: According to the AT Protocol specifications: "Age Assurance rule that applies by default."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigRegionRuleDefaultDefintion: Sendable, Codable {

        ///
        public let access: AccessDefinition
    }


    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: "Age Assurance rule that applies by default."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigRegionRuleIfDeclaredOverAgeDefinition: Sendable, Codable {

        ///
        ///
        /// - Note: According to the AT Protocol specifications: "The age threshold as a whole integer."

        ///
        public let access: AccessDefinition
    }

    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: " "
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigRegionRuleIfDeclaredUnderAgeDefinition: Sendable, Codable {

        ///
        ///
        /// - Note: According to the AT Protocol specifications: "The age threshold as a whole integer."

        ///
        public let access: AccessDefinition
    }

    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: " "
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigRegionRuleIfAssuredOverAgeDefinition: Sendable, Codable {

        ///
        ///
        /// - Note: According to the AT Protocol specifications: "The age threshold as a whole integer."

        ///
        public let access: AccessDefinition
    }

    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: " "
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigRegionRuleIfAssuredUnderAgeDefinition: Sendable, Codable {

        ///
        ///
        /// - Note: According to the AT Protocol specifications: "The age threshold as a whole integer."

        ///
        public let access: AccessDefinition
    }

    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: " "
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigRegionRuleIfAccountNewerThanDefinition: Sendable, Codable {

        ///
        ///
        /// - Note: According to the AT Protocol specifications: "The age threshold as a whole integer."

        ///
        public let access: AccessDefinition
    }

    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: " "
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct ConfigRegionRuleIfAccountOlderThanDefinition: Sendable, Codable {

        ///
        ///
        /// - Note: According to the AT Protocol specifications: "The age threshold as a whole integer."

        ///
        public let access: AccessDefinition
    }

    /// A definition model for
    ///
    /// - Note: According to the AT Protocol specifications: " "
    ///
    /// - SeeAlso: This is based on the [`app.bsky.ageassurance.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/ageassurance/defs.json
    public struct EventDefinition: Sendable, Codable {

    }
}
