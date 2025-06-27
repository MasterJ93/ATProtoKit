//
//  ATMarco.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-21.
//

@available(*, deprecated)
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
