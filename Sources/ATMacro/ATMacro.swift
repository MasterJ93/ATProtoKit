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
///         "embedExternalView": "AppBskyLexicon.Embed.ExternalDefinition.View",
///         "embedImagesView": "AppBskyLexicon.Embed.ImagesDefinition.View",
///         "embedRecordView": "AppBskyLexicon.Embed.RecordDefinition.View",
///         "embedRecordWithMediaView": "AppBskyLexicon.Embed.RecordWithMediaDefinition.View"
///}
/// ```
///
/// The above code will produce the following:
/// ```swift
/// extension ATUnion {
///     public enum EmbedViewUnion: Codable, Sendable {
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

/// A helper macro for lexicon models.
///
/// This automatically creates the `init()`, `init(from decoder: any Decoder) throws`,
/// and `encode(to encoder: Encoder) throws` methods from `Codable` if it wasn't created manually.
///
/// The `truncation` parameter lets you add truncate arrays and string values. The order is
/// as follows:\
/// `[String : (Int?, Int?)]`\
///   - Key (`String`): The name of the property.
///   - Value (`(Int?, Int?)`): The numbers which indicates the maximum number of `String`
///   characters and array items respectively.
///
/// - Important: If you enter a dictionary entry, you must input at least one number inside of
/// the tuple. Put `nil` inside the appropriate part of the tuple if there's no limit. If there's
/// no `String` as the value's property, the first `Int` of the tuple will be ignored. If there's
/// no array as the value's property, the second `Int` of the tuple will be ignored.
///
///```swift
/// @LexiconModel(truncation: ["recordKey" : (15, nil)])
/// public struct CreateRecordRequestBody: Codable {
///     public let repositoryDID: String
///     public let collection: String
///     public let recordKey: String?
///     public let shouldValidate: Bool?
///     public let record: UnknownType
///     public let swapCommit: String?
/// }
///```
///
/// produces the following:
/// ```swift
/// public struct CreateRecordRequestBody: Codable {
///     public let repositoryDID: String
///     public let collection: String
///     public let recordKey: String?
///     public let shouldValidate: Bool?
///     public let record: UnknownType
///     public let swapCommit: String?
///
///     public init(repositoryDID: String, collection: String, recordKey: String?, shouldValidate: Bool?, record: UnknownType, swapCommit: String?) {
///         self.repositoryDID = repositoryDID
///         self.collection = collection
///         self.recordKey = recordKey
///         self.shouldValidate = shouldValidate
///         self.record = record
///         self.swapCommit = swapCommit
///     }
///
///     public init(from decoder: any Decoder) throws {
///         let container = try decoder.container(keyedBy: CodingKeys.self)
///         self.repositoryDID = try container.decode(String.self, forKey: .repositoryDID)
///         self.collection = try container.decode(String.self, forKey: .collection)
///         self.recordKey = try container.decodeIfPresent(String.self, forKey: .recordKey)
///         self.shouldValidate = try container.decodeIfPresent(Bool.self, forKey: .shouldValidate)
///         self.record = try container.decode(UnknownType.self, forKey: .record)
///         self.swapCommit = try container.decodeIfPresent(String.self, forKey: .swapCommit)
///     }
///
///     public func encode(to encoder: any Encoder) throws {
///         var container = encoder.container(keyedBy: CodingKeys.self)
///         try container.encode(self.repositoryDID, forKey: .repositoryDID)
///         try container.encode(self.collection, forKey: .collection)
///         try truncatedEncodeIfPresent(self.recordKey, withContainer: &container, forKey: .recordKey, upToCharacterLength: 15)
///         try container.encodeIfPresent(self.shouldValidate, forKey: .shouldValidate)
///         try container.encode(self.record, forKey: .record)
///         try container.encodeIfPresent(self.swapCommit, forKey: .swapCommit)
///     }
///
///     enum CodingKeys: String, CodingKey {
///         case repositoryDID
///         case collection
///         case recordKey
///         case shouldValidate
///         case record
///         case swapCommit
///     }
/// }
/// ```
///
/// - Parameter truncation: A dictionary which contains some information related to what's
///   being truncated. Optional.
@attached(member, names: arbitrary)
public macro ATLexiconModel(truncation: [String : (Int?, Int?)]? = nil) = #externalMacro(module: "Macros", type: "ATLexiconModelMacro")
