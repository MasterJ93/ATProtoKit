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
    public struct GetConfiguration: Codable {

        /// The service configuration of the Ozone server.
        public struct ServiceConfiguration: Codable {
            
            /// The URL of the service configuration. Optional.
            public let serviceURL: String?
        }

        /// The view configuration of the Ozone server.
        public enum ViewerConfiguration: String, Codable {

            /// Indicates an adminstrator role.
            case roleAdmin = "tools.ozone.team.defs#roleAdmin"

            /// Indicates an moderator role.
            case roleModerator = "tools.ozone.team.defs#roleModerator"

            /// Indicates a triage role.
            case roleTriage = "tools.ozone.team.defs#roleTriage"
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
    public struct GetConfigurationOutput: Codable {

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
    }
}
