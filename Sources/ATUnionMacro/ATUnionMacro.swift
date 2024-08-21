//
//  ATUnionMacro.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-18.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftCompilerPlugin


/// A marco that adds an enum for the purposes of adding a union type for a given lexicon.
///
/// To use the macro, attach it to an extension. It's recommended to attach it to a struct.
/// The macro should contain an array of all of the appropirate structures relevant for the
/// union type.
///
/// ```swift
/// @ATUnion(named: "EmbedViewUnion", containing: [
///     "embedExternalView": AppBskyLexicon.Embed.ExternalDefinition.View.Type,
///     "embedImagesView": AppBskyLexicon.Embed.ImagesDefinition.View.Type,
///     "embedRecordView": AppBskyLexicon.Embed.RecordDefinition.View.Type,
///     "embedRecordWithMediaView": AppBskyLexicon.Embed.RecordWithMediaDefinition.View.Type
/// ])
/// extension ATUnion {}
/// ```
///
/// The above code will produce the following:
/// ```swift
/// extension ATUnion {
///
///     public enum EmbedViewUnion: Codable {
///         case embedExternalView(AppBskyLexicon.Embed.ExternalDefinition.View)
///         case embedImagesView(AppBskyLexicon.Embed.ImagesDefinition.View)
///         case embedRecordView(AppBskyLexicon.Embed.RecordDefinition.View)
///         case embedRecordWithMediaView(AppBskyLexicon.Embed.RecordWithMediaDefinition.View)
///
///         public init(from decoder: Decoder) throws {
///             let container = try decoder.singleValueContainer()
///
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
///
///         public func encode(to encoder: Encoder) throws {
///             var container = encoder.singleValueContainer()
///
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
public struct ATUnionMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        
    }
}


@main
struct ATMacro: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ATUnionMacro.self
    ]
}
