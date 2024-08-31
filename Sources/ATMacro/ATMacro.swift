//
//  ATMarco.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-21.
//

/// A marco that adds an enum for the purposes of adding a union type for a given lexicon.
///
/// To use the macro, put it inside of an extension. It's recommended to attach it to a struct.
/// The macro should contain an array of all of the appropirate structures relevant for the
/// union type.
///
/// ```swift
/// extension ATUnion {
///     #ATUnionBuilder(named: "EmbedViewUnion", containing: [
///         "embedExternalView": AppBskyLexicon.Embed.ExternalDefinition.View.Type,
///         "embedImagesView": AppBskyLexicon.Embed.ImagesDefinition.View.Type,
///         "embedRecordView": AppBskyLexicon.Embed.RecordDefinition.View.Type,
///         "embedRecordWithMediaView": AppBskyLexicon.Embed.RecordWithMediaDefinition.View.Type
///}
/// ```
///
/// The above code will produce the following:
/// ```swift
/// extension ATUnion {
///     public enum EmbedViewUnion: Codable {
///         case embedExternalView(AppBskyLexicon.Embed.ExternalDefinition.View)
///         case embedImagesView(AppBskyLexicon.Embed.ImagesDefinition.View)
///         case embedRecordView(AppBskyLexicon.Embed.RecordDefinition.View)
///         case embedRecordWithMediaView(AppBskyLexicon.Embed.RecordWithMediaDefinition.View)
///         public init(from decoder: Decoder) throws {
///             let container = try decoder.singleValueContainer()
///             if let value = try? container.decode(AppBskyLexicon.Embed.ExternalDefinition.View.self) {
///                 self = .embedExternalView(value)
///             } else if let value = try? container.decode(AppBskyLexicon.Embed.ImagesDefinition.View.self) {
///                 self = .embedImagesView(value)
///             } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordDefinition.View.self) {
///                 self = .embedRecordView(value)
///             } else if let value = try? container.decode(AppBskyLexicon.Embed.RecordWithMediaDefinition.View.self) {
///                 self = .embedRecordWithMediaView(value)
///             } else {
///                 throw DecodingError.typeMismatch(
///                     EmbedViewUnion.self, DecodingError.Context(
///                         codingPath: decoder.codingPath, debugDescription: "Unknown EmbedViewUnion type"))
///             }
///         }
///         public func encode(to encoder: Encoder) throws {
///             var container = encoder.singleValueContainer()
///             switch self {
///                 case .embedExternalView(let embedExternalView):
///                     try container.encode(embedExternalView)
///                 case .embedImagesView(let embedImagesView):
///                     try container.encode(embedImagesView)
///                 case .embedRecordView(let embedRecordView):
///                     try container.encode(embedRecordView)
///                 case .embedRecordWithMediaView(let embedRecordWithMediaView):
///                     try container.encode(embedRecordWithMediaView)
///             }
///         }
///     }
/// }
/// ```
@freestanding(declaration, names: arbitrary)
public macro ATUnionBuilder(named: String, containing: [String: String]) = #externalMacro(module: "Macros", type: "ATUnionBuilderMacro")


/// A macro that truncates items in the property before use.
///
/// To use the macro, use it in replacement from the actual property.
///
/// ```swift
/// public struct KnownFollowers: Codable {
///
///     /// The number of mutual followers related to the parent structure's specifications.
///     #TruncatedProperty(accessor: .let, type: Int.self, named: count, arrayLength: 5)
///
///     /// An array of user accounts that follow the viewer.
///     public let followers: [ProfileViewBasicDefinition]
/// }
/// ```
///
/// The above code will produce the following:
/// ```swift
/// public struct KnownFollowers: Codable {
///
///     /// The number of mutual followers related to the parent structure's specifications.
///     public let count: Int {
///         k
///     }
///
///     /// An array of user accounts that follow the viewer.
///     public let followers: [ProfileViewBasicDefinition]
/// }
/// ```
@freestanding(declaration, names: arbitrary)
public macro TruncatedProperty<T>(accessor: String,
                                  type: T.Type,
                                  named: String,
                                  arrayLength: Int? = nil,
                                  characterLength: Int? = nil
) = #externalMacro(module: "Macros", type: "ATTruncatedPropertyMacro")


/// A macro that formats the date to and from the required formats in the AT Protocol.
///
/// To use the macro, use it in replacement from the actual propery.
///
/// ```swift
/// public struct ReasonRepostDefinition: Codable {
///
///     /// The basic details of the user who reposted the post.
///     public let by: AppBskyLexicon.Actor.ProfileViewBasicDefinition
///
///     /// The last time the repost was indexed.
///     #DateFormatting(named: "indexedAt", isOptional: false)
///
///     enum CodingKeys: CodingKey {
///         case by
///         case indexedAt
///     }
/// }
/// ```
/// 
/// The above code will produce the following:
/// ```swift
/// public struct ReasonRepostDefinition: Codable {
///
///     /// The basic details of the user who reposted the post.
///     public let by: AppBskyLexicon.Actor.ProfileViewBasicDefinition
///
///     /// The last time the repost was indexed.
///     @DateFormatting public var indexedAt: Date
///
///     enum CodingKeys: CodingKey {
///         case by
///         case indexedAt
///     }
/// }
/// ```
@freestanding(declaration, names: arbitrary)
public macro ATDateFormatting(named: String, isOptional: Bool = false) = #externalMacro(module: "Macros", type: "ATDateFormattingMacro")
