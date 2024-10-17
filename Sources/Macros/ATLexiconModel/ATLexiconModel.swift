//
//  ATLexiconModel.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-12.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct ATLexiconModelMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
              arguments.count > 0 else {
            return []
        }

        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw CustomError.message("This macro can only be used in structs.")
        }

//        let initializers = structDecl.memberBlock.members.compactMap { $0.decl.as(InitializerDeclSyntax.self)?.description }
//        let functions = structDecl.memberBlock.members.compactMap { $0.decl.as(FunctionDeclSyntax.self)?.description }

        let members = structDecl.memberBlock.members

        guard members.count > 0 else {
            throw CustomError.message("Struct must contain at least one property.")
        }

        var argumentDictionary = buildDictionary(from: arguments)
        let mapProperties = try mapProperties(from: members, dictionary: &argumentDictionary)

        var initFuncDecl: InitializerDeclSyntax
        var decodeFuncDecl: InitializerDeclSyntax
        var encodeFuncDecl: FunctionDeclSyntax

        let initFuncDeclVariables = try initializeProperties(using: mapProperties)

//        let initFuncSignatureCheck = extractAndValidateSignature(signatureLines: initializers, expectedSignature: initFuncDeclVariables.0)

        initFuncDecl = try InitializerDeclSyntax("public init(\(raw: initFuncDeclVariables.0))") {
            for variable in initFuncDeclVariables.1 {
                variable
            }
        }.with(\.leadingTrivia, .newlines(2))

//        let initDecoderSignatureCheck = extractAndValidateSignature(signatureLines: initializers, expectedSignature: initFuncDeclVariables.0)

        decodeFuncDecl = try InitializerDeclSyntax("public init(from decoder: Decoder) throws") {
            try VariableDeclSyntax("let container = try decoder.container(keyedBy: CodingKeys.self)").with(\.trailingTrivia, .newlines(2))

            for decodedProperty in try decodeProperties(using: mapProperties) {
                decodedProperty
            }
        }.with(\.leadingTrivia, .newlines(2))

//        let encoderSignatureCheck = extractAndValidateSignature(signatureLines: initializers, expectedSignature: initFuncDeclVariables.0)

        encodeFuncDecl = try FunctionDeclSyntax("public func encode(to encoder: Encoder) throws") {
            try VariableDeclSyntax("var container = encoder.container(keyedBy: CodingKeys.self)").with(\.trailingTrivia, .newlines(2))

            for encodedProperty in try encodeProperties(using: mapProperties) {
                encodedProperty
            }
        }

        return [
            DeclSyntax(stringLiteral: initFuncDecl.formatted().description),
            DeclSyntax(stringLiteral: decodeFuncDecl.formatted().description),
            DeclSyntax(stringLiteral: encodeFuncDecl.formatted().description)
        ]
    }

    private static func buildDictionary(from arguments: LabeledExprListSyntax) -> [String : (String?, String?)] {
        var argumentKeyValuePairs: [String : (String?, String?)] = [:]

        arguments.first?
            .expression.as(DictionaryExprSyntax.self)?
            .content.as(DictionaryElementListSyntax.self)?
            .forEach {
                guard let key = $0.key.as(StringLiteralExprSyntax.self)?
                    .segments.as(StringLiteralSegmentListSyntax.self)?
                    .description else {
                    return
                }

                var value1: String?
                var value2: String?
                let valueTuple = $0.value.as(TupleExprSyntax.self)?
                    .elements.as(LabeledExprListSyntax.self)

                value1 = valueTuple?.first?.expression.as(IntegerLiteralExprSyntax.self)?.description
                value2 = valueTuple?.last?.expression.as(IntegerLiteralExprSyntax.self)?.description

                argumentKeyValuePairs[key] = (value1, value2)
            }

        return argumentKeyValuePairs
    }

    private static func mapProperties(from members: MemberBlockItemListSyntax, dictionary: inout [String: (String?, String?)]) throws -> [PropertyMap] {
        let propertyAccessModifierDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self)?.modifiers.first?.name.text ?? "none" }
        let propertyBindingSpecifierDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self)?.bindingSpecifier.text }
        let propertyNameDecl = members.compactMap {
            $0.decl.as(VariableDeclSyntax.self)?.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
        }
        let propertyTypeDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self)?.bindings.first?.typeAnnotation?.type }

        var propertyMaps: [PropertyMap] = []

        let mergedArray = zip(propertyAccessModifierDecl, zip(propertyBindingSpecifierDecl, zip(propertyNameDecl, propertyTypeDecl)))
            .map { (accessModifier, bindingElements) -> (String, String, String, TypeSyntaxProtocol) in
                let (bindingSpecifier, nameAndType) = bindingElements
                let (propertyName, propertyType) = nameAndType

                return (accessModifier, bindingSpecifier, propertyName, propertyType)
            }

        for (accessModifier, bindingSpecifier, propertyName, propertyType) in mergedArray {
            var resolvedType: String = "_unknownType"
            var isArray = false
            var isOptional = false

            if propertyType.is(IdentifierTypeSyntax.self) {
                resolvedType = propertyType.as(IdentifierTypeSyntax.self)?.name.text ?? "_unknownType"
            } else if propertyType.is(ArrayTypeSyntax.self) {
                isArray = true
                resolvedType = "[\(propertyType.as(ArrayTypeSyntax.self)?.element.as(IdentifierTypeSyntax.self)?.name.text ?? "_unknownType")]"
            } else if propertyType.is(OptionalTypeSyntax.self) {
                isOptional = true
                let propertyOptionalType = propertyType.as(OptionalTypeSyntax.self)
                if propertyOptionalType?.wrappedType.is(ArrayTypeSyntax.self) == true {
                    isArray = true
                    resolvedType =
                    "[\(propertyOptionalType?.wrappedType.as(ArrayTypeSyntax.self)?.element.as(IdentifierTypeSyntax.self)?.name.text ?? "_unknownType")]?"
                } else {
                    resolvedType = "\(propertyOptionalType?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text ?? "_unknownType")?"
                }
            }

            var stringCharacters: String? = nil
            var arrayItems: String? = nil

            let dict = checkAndRemoveKey(from: &dictionary, key: propertyName)

            if dict.found == true {
                stringCharacters = dict.value?.0
                arrayItems = dict.value?.1
            }

            let propertyMap = PropertyMap(
                accessModifier: accessModifier.isEmpty ? nil : accessModifier,
                bindingSpecifier: bindingSpecifier,
                name: propertyName,
                type: resolvedType,
                isArray: isArray,
                isOptional: isOptional,
                stringCharacters: stringCharacters,
                arrayItems: arrayItems
            )

            propertyMaps.append(propertyMap)

            print("Access Modifier: \(accessModifier), Binding Specifier: \(bindingSpecifier), Property Name: \(propertyName), Type: \(resolvedType), Is Array: \(isArray), Is Optional: \(isOptional)")
        }

        if !dictionary.isEmpty {
            let remainingKeys = dictionary.keys.joined(separator: ", ")
            throw CustomError.message(
                "Argument mismatch in macro: \(remainingKeys)\n\nEnsure the spelling of each argument matches the names of the struct's property."
            )
        }

        return propertyMaps
    }

    private static func checkAndRemoveKey(
        from dictionary: inout [String: (String?, String?)],
        key: String
    ) -> (found: Bool, key: String?, value: (String?, String?)?) {

        if let value = dictionary[key] {
            dictionary.removeValue(forKey: key)
            return (true, key, value)
        } else {
            return (false, nil, nil)
        }
    }

    private static func initializeProperties(using propertyMaps: [PropertyMap]) throws -> (String, [DeclSyntax]) {
        var declSyntax: [DeclSyntax] = []

        var initSignature: String = ""
        var initVariables: String = ""

        for (index, propertyMap) in propertyMaps.enumerated() {
            let propertyName = propertyMap.name
            let propertyType = propertyMap.type

            initVariables.append("self.\(propertyName) = \(propertyName)\n")

            if index == propertyMaps.startIndex {
                initSignature.append("\(propertyName): \(propertyType)")
            } else if index == propertyMaps.endIndex {
                initSignature.append(", \(propertyName): \(propertyType)")
            } else {
                initSignature.append(", \(propertyName): \(propertyType)")
            }

        }

        declSyntax.append(DeclSyntax(stringLiteral: initVariables))
        return (
            initSignature,
            declSyntax
        )
    }

    private static func extractAndValidateSignature(signatureLines: [String], expectedSignature: String) -> Bool {
        // Join the array of strings into a single string
        let signature = signatureLines.joined(separator: " ")

        // Find the index of the first '{'
        if let index = signature.firstIndex(of: "{") {
            // Extract everything before the '{'
            let extractedSignature = String(signature[..<index]).trimmingCharacters(in: .whitespacesAndNewlines)

            // Check if the extracted signature matches the expected signature
            return extractedSignature == expectedSignature
        }

        // If there's no '{', it's not valid
        return false
    }

    private static func decodeProperties(using propertyMaps: [PropertyMap]) throws -> [DeclSyntax] {
        var declSyntax: [DeclSyntax] = []

        var decodedVariables: String = ""

        for propertyMap in propertyMaps {
            // Check if the property type is `Date` or `Date?`.
            var propertyNameVariable: String = "\(propertyMap.name)"
            let decodeFunctionDecl: String = "decode"
            var decodedType: String = "\(propertyMap.type)"
            let propertyName: String = "\(propertyMap.name)"

            if propertyMap.type == "Date" {
                decodedType = "DateFormatting"
                propertyNameVariable = "_\(propertyMap.name)"
            }

            if propertyMap.isArray {
                decodedType = "\(decodedType)"
            }

            if decodedType != "DateFormatting" {
                // Remove the trailing '?' if it exists
                decodedType = decodedType.hasSuffix("?") ? String(decodedType.dropLast()) : decodedType
            } else {
                decodedType = "DateFormattingOptional"
            }

            decodedVariables.append(
                    """
                    self.\(propertyNameVariable) = try container.\(decodeFunctionDecl)(\(decodedType).self, forKey: .\(propertyName))\n
                    """
            )
        }

        declSyntax.append(DeclSyntax(stringLiteral: decodedVariables))
        return declSyntax
    }

    private static func encodeProperties(using propertyMaps: [PropertyMap]) throws -> [DeclSyntax] {
        var declSyntax: [DeclSyntax] = []

        var encodedVariables: String = ""

        for propertyMap in propertyMaps {
            let propertyNameVariable: String = "\(propertyMap.name)"
            var encodedType: String = "\(propertyMap.type)"
            var encodedKind: String = "container.encode"
            var container: String = ""
            var characterLength: String = ""
            let arrayItems: String = ""

            // Check if truncation is involved.
            if propertyMap.stringCharacters != nil || propertyMap.arrayItems != nil {
                encodedKind = "truncatedEncode"
                container = ", withContainer: &container"

                if let stringCharacters = propertyMap.stringCharacters, !stringCharacters.isEmpty {
                    characterLength = ", upToCharacterLength: \(stringCharacters)"
                }

                if var arrayItems = propertyMap.arrayItems, !arrayItems.isEmpty {
                    arrayItems = ", upToArrayLength: \(arrayItems)"
                }
            }

            // Check if the type is an array.
            if propertyMap.isArray {
                encodedType = "[\(encodedType)]"
            }

            // Check if the type is optional.
            if propertyMap.isOptional {
                encodedType = "\(encodedType)?"
                encodedKind = "\(encodedKind)IfPresent"
            }

            encodedVariables.append(
                    """
                    try \(encodedKind)(self.\(propertyNameVariable)\(container), forKey: .\(propertyNameVariable)\(characterLength)\(arrayItems))\n
                    """
            )
        }

        declSyntax.append(DeclSyntax(stringLiteral: encodedVariables))
        return declSyntax
    }
}
