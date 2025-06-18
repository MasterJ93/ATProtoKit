//
//  ToolsOzoneHostingGetAccountHistory.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-05-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Hosting {

    /// The main data model definition for getting the account history of a given user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get account history, e.g. log of updated
    /// email addresses or other identity information."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.hosting.getAccountHistory`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/hosting/getAccountHistory.json
    public struct GetAccountHistory: Sendable, Codable {

        /// An account event.
        public enum Events: String, Sendable, Codable {

            /// An "Account Created" event.
            case accountCreated

            /// An "Email Updated: event.
            case emailUpdated

            /// An "Email Confirmed" event.
            case emailConfirmed

            /// A "Password Confirmed" event.
            case passwordConfirmed

            /// A "Handle Updated" event.
            case handleUpdated
        }

        /// An account event.
        public struct Event: Sendable, Codable {

            /// An individual event detail.
            public let details: DetailsUnion

            /// The user account that created the event detail.
            public let createdBy: String

            /// The date and time the event detail was created.
            public let createdAt: Date

            public init(details: DetailsUnion, createdBy: String, createdAt: Date) {
                self.details = details
                self.createdBy = createdBy
                self.createdAt = createdAt
            }

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.details = try container.decode(DetailsUnion.self, forKey: .details)
                self.createdBy = try container.decode(String.self, forKey: .createdBy)
                self.createdAt = try container.decodeDate(forKey: .createdAt)
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(self.details, forKey: .details)
                try container.encode(self.createdBy, forKey: .createdBy)
                try container.encodeDate(self.createdAt, forKey: .createdAt)
            }

            enum CodingKeys: CodingKey {
                case details
                case createdBy
                case createdAt
            }

            // Unions
            /// A reference containing the list of event details.
            public enum DetailsUnion: ATUnionProtocol {

                /// An "Account Created" event.
                case accountCreated(AccountCreated)

                /// An "Email Updated: event.
                case emailUpdated(EmailUpdated)

                /// An "Email Confirmed" event.
                case emailConfirmed(EmailConfirmed)

                /// A "Password Confirmed" event.
                case passwordConfirmed(PasswordConfirmed)

                /// A "Handle Updated" event.
                case handleUpdated(HandleUpdated)

                /// An unknown case.
                case unknown(String, [String: CodableValue])

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let type = try container.decode(String.self, forKey: .type)

                    switch type {
                        case "tools.ozone.hosting.getAccountHistory#accountCreated":
                            self = .accountCreated(try ToolsOzoneLexicon.Hosting.GetAccountHistory.AccountCreated(from: decoder))
                        case "tools.ozone.hosting.getAccountHistory#emailUpdated":
                            self = .emailUpdated(try ToolsOzoneLexicon.Hosting.GetAccountHistory.EmailUpdated(from: decoder))
                        case "tools.ozone.hosting.getAccountHistory#emailConfirmed":
                            self = .emailConfirmed(try ToolsOzoneLexicon.Hosting.GetAccountHistory.EmailConfirmed(from: decoder))
                        case "tools.ozone.hosting.getAccountHistory#passwordUpdated":
                            self = .passwordConfirmed(try ToolsOzoneLexicon.Hosting.GetAccountHistory.PasswordConfirmed(from: decoder))
                        case "tools.ozone.hosting.getAccountHistory##handleUpdated":
                            self = .handleUpdated(try ToolsOzoneLexicon.Hosting.GetAccountHistory.HandleUpdated(from: decoder))
                        default:
                            let singleValueDecodingContainer = try decoder.singleValueContainer()
                            let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                            self = .unknown(type, dictionary)
                    }
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()

                    switch self {
                        case .accountCreated(let value):
                            try container.encode(value)
                        case .emailUpdated(let value):
                            try container.encode(value)
                        case .emailConfirmed(let value):
                            try container.encode(value)
                        case .passwordConfirmed(let value):
                            try container.encode(value)
                        case .handleUpdated(let value):
                            try container.encode(value)
                        default:
                            break
                    }
                }

                enum CodingKeys: String, CodingKey {
                    case type = "$type"
                }
            }
        }

        /// An "account created" event.
        public struct AccountCreated: Sendable, Codable {

            /// The email address of the user account. Optional.
            public let email: String?

            /// The handle of the user account. Optional.
            public let handle: String?
        }

        /// An "email updated" event.
        public struct EmailUpdated: Sendable, Codable {

            /// The new email address for the user account.
            public let newEmail: String

            enum CodingKeys: String, CodingKey {
                case newEmail = "email"
            }
        }

        /// An "email confirmed" event.
        public struct EmailConfirmed: Sendable, Codable {

            /// The confirmed email address for the user account.
            public let email: String
        }

        /// A "password confirmed" event.
        public struct PasswordConfirmed: Sendable, Codable {}

        /// A "handle updated" event.
        public struct HandleUpdated: Sendable, Codable {

            /// The new handle for the user account.
            public let newHandle: String

            enum CodingKeys: String, CodingKey {
                case newHandle = "handle"
            }
        }
    }

    /// An output model for getting the account history of a given user account.
    ///
    /// - Note: According to the AT Protocol specifications: "Get account history, e.g. log of updated
    /// email addresses or other identity information."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.hosting.getAccountHistory`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/hosting/getAccountHistory.json
    public struct GetAccountHistoryOutput: Sendable, Codable {

        /// The mark used to indicate the starting point for the next set of results. Optional.
        public let cursor: String?

        /// An array of events.
        public let events: [GetAccountHistory.Event]
    }
}
