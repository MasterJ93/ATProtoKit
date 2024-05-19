//
//  AppBskyLabelerGetServices.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Labeler {

    /// The main data model definition for the output of the labeler service information.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a list of
    /// labeler services."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.getServices`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/getServices.json
    public struct LabelerGetServicesOutput: Codable {

        /// A labeler view.
        public let views: LabelerViewUnion
    }
}
