//
//  ToolsOzoneServerGetConfig.swift
//
//
//  Created by Christopher Jr Riley on 2024-06-05.
//

import Foundation

extension ToolsOzoneLexicon.Server {

    /// The main data model definition for retrieving details about the Ozone
    /// server's configuration.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about ozone's
    /// server configuration."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.server.getConfig`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/server/getConfig.json
    public struct GetConfiguration: Sendable, Codable {

        /// The service configuration of the Ozone server.
        public struct ServiceConfiguration: Sendable, Codable {

            /// The URL of the service configuration. Optional.
            public let serviceURL: String?
        }

        /// The view configuration of the Ozone server.
        public enum ViewerConfiguration: String, Sendable, Codable {

            /// Indicates an adminstrator role.
            case roleAdmin = "tools.ozone.team.defs#roleAdmin"

            /// Indicates an moderator role.
            case roleModerator = "tools.ozone.team.defs#roleModerator"

            /// Indicates a triage role.
            case roleTriage = "tools.ozone.team.defs#roleTriage"

            /// Indicates a role verifier.
            case roleVerifier = "tools.ozone.team.defs#roleVerifier"
        }
    }

    /// An output model for retrieving details about the Ozone server's configuration.
    ///
    /// - Note: According to the AT Protocol specifications: "Get details about ozone's
    /// server configuration."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.server.getConfig`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/server/getConfig.json
    public struct GetConfigurationOutput: Sendable, Codable {

        /// The AppView configurations of the Ozone server.
        public let appview: GetConfiguration.ServiceConfiguration?

        /// The Personal Data Server (PDS) configurations of the Ozone server.
        public let pds: GetConfiguration.ServiceConfiguration?

        /// The blob divert configurations of the Ozone server.
        public let blobDivert: GetConfiguration.ServiceConfiguration?

        /// The chat service configurations of the Ozone server.
        public let chat: GetConfiguration.ServiceConfiguration?

        /// The viewer configurations of the Ozone server.
        public let viewer: GetConfiguration.ViewerConfiguration?

        /// The decentralized identifier of the configuration.
        ///
        /// - Note: According to the AT Protocol specifications: "The did of the verifier used
        /// for verification."
        public let verifierDID: String

        enum CodingKeys: String, CodingKey {
            case appview
            case pds
            case blobDivert
            case chat
            case viewer
            case verifierDID = "verifierDid"
        }
    }
}
