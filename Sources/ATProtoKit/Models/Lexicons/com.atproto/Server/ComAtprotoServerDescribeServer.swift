//
//  ComAtprotoServerDescribeServer.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Server {

    /// A data model for retrieving a description of the server.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.describeServer`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/describeServer.json
    public struct DescribeServer: Sendable, Codable {

        /// A data model of service policy URLs.
        ///
        /// - Note: According to the AT Protocol specifications: "Describes the server's account
        /// creation requirements and capabilities. Implemented by PDS."
        ///
        /// - SeeAlso: This is based on the [`com.atproto.server.describeServer`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/describeServer.json
        public struct ServicePolicyURLs: Sendable, Codable {

            /// The URL for the server's Privacy Policy. Optional.
            public let privacyPolicyURL: URL?

            /// The URL for the server's Terms of Service. Optional.
            public let termsOfServiceURL: URL?

            enum CodingKeys: String, CodingKey {
                case privacyPolicyURL = "privacyPolicy"
                case termsOfServiceURL = "termsOfService"
            }
        }

        /// A data model definition of the server's contact information.
        ///
        /// - SeeAlso: This is based on the [`com.atproto.server.describeServer`][github] lexicon.
        ///
        /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/describeServer.json
        public struct ContactInformation: Sendable, Codable {

            /// The email address users can use to contact the server owner.
            public let email: String
        }
    }

    /// An output model for retrieving a description of the server.
    ///
    /// - Note: According to the AT Protocol specifications: "Describes the server's account
    /// creation requirements and capabilities. Implemented by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.describeServer`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/describeServer.json
    public struct DescribeServerOutput: Sendable, Codable {

        /// Indicates whether an invite code is required to join the server. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "If true, an invite code must
        /// be supplied to create an account on this instance."
        public let isInviteCodeRequired: Bool?

        /// Indicates whether the user is required to verify using a phone number. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "If true, a phone verification
        /// token must be supplied to create an account on this instance."
        public let isPhoneVerificationRequired: Bool?

        /// An array of available user domains.
        ///
        /// - Note: According to the AT Protocol specifications: "List of domain suffixes that
        /// can be used in account handles."
        public let availableUserDomains: [String]

        /// A group of URLs for the server's service policies. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "URLs of service
        /// policy documents."
        public let servicePolicyURLs: DescribeServer.ServicePolicyURLs?

        /// The contact information for the server.
        ///
        /// - Note: According to the AT Protocol specifications: "Contact information."
        public let contactInformation: DescribeServer.ContactInformation?

        /// The decentralized identifier (DID) of the server.
        public let serverDID: String

        enum CodingKeys: String, CodingKey {
            case isInviteCodeRequired = "inviteCodeRequired"
            case isPhoneVerificationRequired = "phoneVerificationRequired"
            case availableUserDomains
            case servicePolicyURLs = "links"
            case contactInformation = "contact"
            case serverDID = "did"
        }
    }
}
