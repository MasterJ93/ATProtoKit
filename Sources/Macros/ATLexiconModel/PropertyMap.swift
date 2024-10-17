//
//  PropertyMap.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-12.
//

import Foundation

public struct PropertyMap {
    public let accessModifier: String?
    public let bindingSpecifier: String
    public let name: String
    public let type: String
    public let isArray: Bool
    public let isOptional: Bool
    public let stringCharacters: String?
    public let arrayItems: String?
}
