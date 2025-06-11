//
//  AppBskyLabelerGetServices.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

extension AppBskyLexicon.Labeler {

    /// An output model for the labeler service information.
    ///
    /// - Note: According to the AT Protocol specifications: "Get information about a list of
    /// labeler services."
    ///
    /// - SeeAlso: This is based on the [`app.bsky.labeler.getServices`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/labeler/getServices.json
    public struct GetServicesOutput: Sendable, Codable {

        /// An array of labeler views.
        public let views: [ViewsUnion]

        /// An array of labeler views.
        public enum ViewsUnion: ATUnionProtocol {

            /// A labeler view.
            case labelerView(AppBskyLexicon.Labeler.LabelerViewDefinition)

            /// A detailed view of a labeler.
            case labelerViewDetailed(AppBskyLexicon.Labeler.LabelerViewDetailedDefinition)

            /// An unknown case.
            case unknown(String, [String: CodableValue])

            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let type = try container.decode(String.self, forKey: .type)

                switch type {
                    case "app.bsky.labeler.defs#labelerView":
                        self = .labelerView(try AppBskyLexicon.Labeler.LabelerViewDefinition(from: decoder))
                    case "app.bsky.labeler.defs#labelerViewDetailed":
                        self = .labelerViewDetailed(try AppBskyLexicon.Labeler.LabelerViewDetailedDefinition(from: decoder))
                    default:
                        let singleValueDecodingContainer = try decoder.singleValueContainer()
                        let dictionary = try Self.decodeDictionary(from: singleValueDecodingContainer, decoder: decoder)

                        self = .unknown(type, dictionary)
                }
            }

            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()

                switch self {
                    case .labelerView(let labelerView):
                        try container.encode(labelerView)
                    case .labelerViewDetailed(let labelerViewDetailed):
                        try container.encode(labelerViewDetailed)
                    default:
                        break
                }
            }

            enum CodingKeys: String, CodingKey {
                case type = "$type"
            }
        }
    }
}
