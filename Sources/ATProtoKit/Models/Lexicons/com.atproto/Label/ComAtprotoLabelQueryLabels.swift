//
//  ComAtprotoLabelQueryLabels.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Label {

    /// An output model for inding relevant labels based on a given URI.
    ///
    /// - Note: According to the AT Protocol specifications: "Find labels relevant to the provided
    /// AT-URI patterns. Public endpoint for moderation services, though may return different or
    /// additional results with auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.label.queryLabels`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/queryLabels.json
    public struct QueryLabelsOutput: Codable {

        /// An array of labels.
        public let labels: [Label]
    }
}
