//
//  TruncatedPropertyMacro.swift
//
//
//  Created by Christopher Jr Riley on 2024-08-31.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftCompilerPlugin

public struct ATTruncatedPropertyMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        return []
    }
}
