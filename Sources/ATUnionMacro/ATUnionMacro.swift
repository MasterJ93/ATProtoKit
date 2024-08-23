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
public struct ATUnionMacro: PeerMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {

        // Check if the macro is attached to a struct.
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw ATMacroError.onlyApplicableToStruct
        }

        // Check if the macro is attached to "ATUnion".
        if structDecl.name != "ATUnion" {
            throw ATMacroError.onlyApplicableToATUnion
        }

        // Check if the marco has any arguments.
        guard let unionName = node.argumentList.first?.expression,
              let unionCases = node.argumentList.last?.expression else {
            throw ATMacroError.noArguments
        }

        let testing = unionName.as(DictionaryExprSyntax.self)


        var atUnionEnum: String

        atUnionEnum = """
        public enum \(argument): Codable {
        """

        for <#item#> in <#items#> {
            atUnionEnum = atUnionEnum +
            """
                case ()
            """
        }
        return []
    }
}


// MARK: - Errors

/// An error type related to `ATMacro` macros.
public enum ATMacroError: CustomStringConvertible, Error {
    case onlyApplicableToStruct
    case onlyApplicableToATUnion
    case noArguments

    public var description: String {
        switch self {
            case .onlyApplicableToStruct:
                return "This macro can only be applied to a struct"
            case .onlyApplicableToATUnion:
                return "This macro can only be applied to the 'ATUnion' struct."
            case .noArguments:
                return "This macro has no arguments."
        }
    }
}

// MARK: - Main Implementation
@main
struct ATMacro: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ATUnionMacro.self
    ]
}
