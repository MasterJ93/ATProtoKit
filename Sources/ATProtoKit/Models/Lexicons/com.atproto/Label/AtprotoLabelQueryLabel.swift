//
//  AtprotoLabelQueryLabel.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-16.
//

import Foundation

/// The main data model definition for the output of finding relevant labels based on a given URI.
///
/// - Note: According to the AT Protocol specifications: "Find labels relevant to the provided AT-URI patterns. Public endpoint for
/// moderation services, though may return different or additional results with auth."
///
/// - SeeAlso: This is based on the [`com.atproto.label.queryLabels`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/queryLabels.json
public struct LabelQueryLabelOutput: Codable {
    /// An array of labels.
    public let labels: [Label]
}
