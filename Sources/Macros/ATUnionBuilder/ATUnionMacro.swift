//
//  ATUnionMacro.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-18.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
@preconcurrency import SwiftDiagnostics

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
public struct ATUnionBuilderMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let argument = node.argumentList.as(LabeledExprListSyntax.self),
              argument.count > 0 else {
            fatalError("No cases")
        }

        let string = argument
            .children(viewMode: .all)
            .compactMap { $0.as(LabeledExprSyntax.self) }
            .map(\.expression)
            .compactMap { $0.as(StringLiteralExprSyntax.self) }
            .map { String(describing: $0.segments.description) }[0]

        var argumentKeyValuePairs: [(String, String)] = []

        argument
            .children(viewMode: .all)
            .compactMap { $0.as(LabeledExprSyntax.self) }
            .map(\.expression)[1].cast(DictionaryExprSyntax.self).content.as(DictionaryElementListSyntax.self)?.forEach {
                var key: String = ""
                var value: String = ""

                if let keySegments = $0.key
                    .as(StringLiteralExprSyntax.self)?
                    .segments.as(StringLiteralSegmentListSyntax.self) {

                    key = keySegments.description
                }

                if let valueSegments = $0.value
                    .as(StringLiteralExprSyntax.self)?
                    .segments.as(StringLiteralSegmentListSyntax.self) {

                    value = valueSegments.description

                    argumentKeyValuePairs += [(key, value)]
                }
            }

        let enumDecl = try EnumDeclSyntax("public enum \(raw: string): Codable, Sendable") {
            for argumentKeyValuePair in argumentKeyValuePairs {
                try EnumCaseDeclSyntax("case \(raw: argumentKeyValuePair.0)(\(raw: argumentKeyValuePair.1))")
            }

            // Decodable
            try InitializerDeclSyntax("public init(from decoder: Decoder) throws") {
                try VariableDeclSyntax("let container = try decoder.singleValueContainer()")

                try compileDecodableIfStatements(from: argumentKeyValuePairs, enumName: string)
            }

            // Encodable
            try FunctionDeclSyntax("public func encode(to encoder: Encoder) throws") {
                try VariableDeclSyntax("var container = encoder.singleValueContainer()")

                try compileEncodableSwitchStatements(from: argumentKeyValuePairs)
            }
        }

        return [
            DeclSyntax(stringLiteral: enumDecl.formatted().description)
        ]
    }

    private static func compileDecodableIfStatements(from argument: [(String, String)], enumName: String) throws -> DeclSyntax {

        var cases = ""

        for (index, (key, value)) in argument.enumerated() {
            if index == 0 {
                cases.append(
                    """
                    if let value = try? container.decode(\(value).self) {
                        self = .\(key)(value)
                    """
                )
            } else {
                cases.append(
                    """
                    } else if let value = try? container.decode(\(value).self) {
                        self = .\(key)(value)
                    """
                )
            }
        }

        let declSyntax = DeclSyntax(stringLiteral:
            """
            \(cases)
            } else {
                throw DecodingError.typeMismatch(
                    \(enumName).self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Unknown \(enumName) type"))
            }
            """
        )

        return declSyntax
    }

    private static func compileEncodableSwitchStatements(from argument: [(String, String)]) throws -> DeclSyntax {
        var cases = ""

        cases.append(
            """
            switch self {
            """
        )

        for (_, key) in argument.enumerated() {
            cases.append(
                """
                case .\(key.0)(let unionValue):
                        try container.encode(unionValue)
                """
            )
        }

        cases.append(
            """
            }
            """
        )

        return DeclSyntax(stringLiteral: cases)
    }
}
