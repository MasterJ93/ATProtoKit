//
//  PropertyMap.swift
//
//
//  Created by Christopher Jr Riley on 2024-09-12.
//

import Foundation

/// A representation of the metadata for a property.
public struct PropertyMap {

    /// The access modifier of the property. Optional.
    public let accessModifier: String?

    /// The binding specifier of the property.
    public let bindingSpecifier: String

    /// The property's name.
    public let name: String

    /// The property's type.
    public let type: String

    /// Determines whether the type is an array.
    public let isArray: Bool

    /// Determines whether the type is optional.
    public let isOptional: Bool

    /// The maximum number of characters of a `String` type. Optional.
    ///
    /// This can only be used if the property is a `String` type.
    public let stringCharacters: String?

    /// The maximum number of items stored in an `Array` property. Optional.
    ///
    /// This can only be used if the property is an `Array` of another type.
    public let arrayItems: String?
}
