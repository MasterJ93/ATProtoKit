//
//  BskyLabelerGetServices.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-14.
//

import Foundation

/// The main data model definition for the output of the labeler service information.
///
/// - Note: According to the AT Protocol specifications: "Get information about a list of labeler services."
///
/// - SeeAlso: This is based on the [`app.bsky.labeler.getServices`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/getServices.json
public struct LabelerGetServicesOutput: Codable {
    public let views: LabelerViewUnion
}

/// A reference containing the list of labeler views..
public enum LabelerViewUnion: Codable {
    case labelerView(LabelerView)
    case labelerViewDetailed(LabelerViewDetailed)

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(LabelerView.self) {
            self = .labelerView(value)
        } else if let value = try? container.decode(LabelerViewDetailed.self) {
            self = .labelerViewDetailed(value)
        } else {
            throw DecodingError.typeMismatch(ActorPreferenceUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown LabelerViewUnion type"))
        }


    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .labelerView(let labelerView):
                try container.encode(labelerView)
            case .labelerViewDetailed(let labelerViewDetailed):
                try container.encode(labelerViewDetailed)
        }
    }
}
