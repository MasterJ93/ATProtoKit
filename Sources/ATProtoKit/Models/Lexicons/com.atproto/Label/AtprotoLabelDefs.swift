//
//  AtProtoLabelDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// The main data model definition for a label.
///
/// - Note: According to the AT Protocol specifications: "Metadata tag on an atproto resource (eg, repo or record)."
///
/// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
public struct Label: Codable {
    /// The version number of the label. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "The AT Protocol version of the label object."
    public let version: Int?
    /// The decentralized identifier (DID) of the label creator.
    ///
    /// - Note: According to the AT Protocol specifications: "DID of the actor who created this label."
    public let actorDID: String
    /// The URI of the resource the label applies to.
    ///
    /// - Note: According to the AT Protocol specifications: "AT URI of the record, repository (account), or other resource that this label applies to."
    public let atURI: String
    /// The CID hash of the resource the label applies to. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Optionally, CID specifying the specific version of 'uri' resource this label
    /// applies to."
    public let cidHash: String?
    /// The name of the label.
    ///
    /// - Note: According to the AT Protocol specifications: "The short string name of the value or type of this label."
    ///
    /// - Important: Current maximum length is 128 characters. This library will automatically truncate the `String` to the maximum length if it does go over the limit.
    public var name: String
    /// Indicates whether this label is negating a previously-used label. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "If true, this is a negation label, overwriting a previous label."
    public let isNegated: Bool?
    /// The date and time the label was created.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp when this label was created."
    @DateFormatting public var timestamp: Date
    /// The date and time the label expires on.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp at which this label expires (no longer applies)."
    @DateFormattingOptional public var expiresOn: Date?
    /// The DAG-CBOR-encoded signature. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Signature of dag-cbor encoded label."
    public let signature: Data?

    public init(version: Int?, actorDID: String, atURI: String, cidHash: String?, name: String, isNegated: Bool?, timestamp: Date, expiresOn: Date?, signature: Data) {
        self.version = version
        self.actorDID = actorDID
        self.atURI = atURI
        self.cidHash = cidHash
        self.name = name
        self.isNegated = isNegated
        self._timestamp = DateFormatting(wrappedValue: timestamp)
        self._expiresOn = DateFormattingOptional(wrappedValue: expiresOn)
        self.signature = signature
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.version = try container.decodeIfPresent(Int.self, forKey: .version)
        self.actorDID = try container.decode(String.self, forKey: .actorDID)
        self.atURI = try container.decode(String.self, forKey: .atURI)
        self.cidHash = try container.decodeIfPresent(String.self, forKey: .cidHash)
        self.name = try container.decode(String.self, forKey: .name)
        self.isNegated = try container.decodeIfPresent(Bool.self, forKey: .isNegated)
        self.timestamp = try container.decode(DateFormatting.self, forKey: .timestamp).wrappedValue
        self.expiresOn = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .expiresOn)?.wrappedValue
        self.signature = try container.decodeIfPresent(Data.self, forKey: .signature)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.version, forKey: .version)
        try container.encode(self.actorDID, forKey: .actorDID)
        try container.encode(self.atURI, forKey: .atURI)
        try container.encodeIfPresent(self.cidHash, forKey: .cidHash)

        // Truncate `name` to 128 characters before encoding
        try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToLength: 128)

        try container.encodeIfPresent(self.isNegated, forKey: .isNegated)
        try container.encode(self._timestamp, forKey: .timestamp)
        try container.encodeIfPresent(self._expiresOn, forKey: .expiresOn)
        try container.encodeIfPresent(self.signature, forKey: .signature)
    }

    enum CodingKeys: String, CodingKey {
        case version = "ver"
        case actorDID = "src"
        case atURI = "uri"
        case cidHash = "cid"
        case name = "val"
        case isNegated = "neg"
        case timestamp = "cts"
        case expiresOn = "exp"
        case signature = "sig"
    }
}

/// A data model for a definition for an array of self-defined labels.
public struct SelfLabels: Codable {
    /// An array of self-defined tags on a record.
    ///
    /// - Note: According to the AT Protocol specifications: "Metadata tags on an atproto record, published by the author within the record."
    ///
    /// - Important: Current maximum length is 10 tags. This library will automatically truncate the `Array` to the maximum length if it does go over the limit.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
    public let values: [SelfLabel]

    public init(values: [SelfLabel]) {
        self.values = values
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.values = try container.decode([SelfLabel].self, forKey: .values)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Truncate `values` to 10 items before encoding
        try truncatedEncode(self.values, withContainer: &container, forKey: .values, upToLength: 10)
    }

    enum CodingKeys: CodingKey {
        case values
    }
}

/// A data model for a definition for a user-defined label.
///
/// - Note: According to the AT Protocol specifications: "Metadata tag on an atproto record, published by the author within the record. Note that schemas should use #selfLabels, not #selfLabel.",
///
/// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
public struct SelfLabel: Codable {
    /// A user-defined label.
    ///
    /// - Note: According to the AT Protocol specifications: "The short string name of the value or type of this label."
    ///
    /// - Important: Current maximum length is 128 characters. This library will automatically truncate the `String` to the maximum length if it does go over the limit.
    public let value: String

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Truncate `value` to 128 characters before encoding
        try truncatedEncode(self.value, withContainer: &container, forKey: .value, upToLength: 128)
    }

    enum CodingKeys: String, CodingKey {
        case value = "val"
    }
}

/// A data model definition for
///
/// - Note: According to the AT Protocol specifications: "Declares a label value and its expected interpertations and behaviors."
///
/// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
public struct LabelValueDefinition: Codable {
    /// The value of the label.
    ///
    /// - Important: This field can only contain lowercased letter and the hypen (-) character. This library will automatically convert
    /// uppercased letters to lowercased, as well as any hashes other than the hypen into a hypen. All additional characters will be removed.
    ///
    /// - Note: According to the AT Protocol specifications: "The value of the label being defined. Must only include lowercase ascii and the '-' character ([a-z-]+)."
    public let identifier: String
    // TODO: Make this into an enum.
    /// The visual indicator of the label that indicates the severity.
    ///
    /// - Note: According to the AT Protocol specifications: "How should a client visually convey this label? 'inform' means neutral
    /// and informational; 'alert' means negative and warning; 'none' means show nothing."
    public let severity: Severity
    // TODO: Make this into an enum.
    /// Indicates how much of the content should be hidden for the user.
    ///
    /// - Note: According to the AT Protocol specifications: "What should this label hide in the UI, if applied? 'content' hides all of the target;
    /// 'media' hides the images/video/audio; 'none' hides nothing."
    public let blurs: Blurs
    // TODO: Make this into an enum.
    /// The default setting for the label.
    ///
    /// - Note: According to the AT Protocol specifications: "The default setting for this label."
    public let defaultSetting: DefaultSetting = .warn
    /// Indicates whether the "Adult Content" preference needs to be enabled in order to use this label. Optional.
    ///
    /// - Note: According to the AT Protocol specifications: "Does the user need to have adult content enabled in order to configure this label?"
    public let isAdultOnly: Bool?
    /// An array of localized strings for the label. Optional.
    public let locales: [LabelValueDefinitionStrings]

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Ensure `value` is lowercased and only has the standard hyphen (-).
        // Then, truncate `value` to 100 characters before encoding.
        try truncatedEncode(self.identifier.transformToLowerASCIIAndHyphen(), withContainer: &container, forKey: .identifier, upToLength: 100)
        try container.encode(self.severity, forKey: .severity)
        try container.encode(self.blurs, forKey: .blurs)
        try container.encode(self.defaultSetting, forKey: .defaultSetting)
        try container.encodeIfPresent(self.isAdultOnly, forKey: .isAdultOnly)
        try container.encode(self.locales, forKey: .locales)
    }

    enum CodingKeys: CodingKey {
        case identifier
        case severity
        case blurs
        case defaultSetting
        case isAdultOnly
        case locales
    }

    // Enums
    /// The visual indicator of the label that indicates the severity.
    public enum Severity: String, Codable {
        /// Indicates the labeler should only inform the user of the content.
        case inform
        /// Indicates the labeler should alert the user of the content.
        case alert
        /// Indicates the labeler should do nothing.
        case none
    }

    /// Indicates how much of the content should be hidden for the user.
    public enum Blurs: String, Codable {
        /// Indicates the labeler should hide the entire content from the user.
        case content
        /// Indicates the labeler should hide only the media of the content, but keeps the text intact.
        case media
        /// Indicates the labeler should hide nothing.
        case none
    }

    /// The default setting for the label.
    public enum DefaultSetting: String, Codable {
        /// Indicates the user will ignore the label.
        case ignore
        /// Indicates the user will be warned.
        case warn
        /// Indicates the user will hide the label.
        case hide
    }
}

/// A data model definition for a localized description of a label.
///
/// - Note: According to the AT Protocol specifications: "Strings which describe the label in the UI, localized into a specific language."
///
/// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
public struct LabelValueDefinitionStrings: Codable {
    /// The language code of the label's definition.
    ///
    /// - Note: According to the AT Protocol specifications: "The code of the language these strings are written in."
    public let language: Locale
    /// The localized name of the label.
    ///
    /// - Note: According to the AT Protocol specifications: "A short human-readable name for the label."
    public let name: String
    /// The localized description of the label.
    ///
    /// - Note: According to the AT Protocol specifications: "A longer description of what the label means and why it might be applied."
    public let description: String

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.language = try container.decode(Locale.self, forKey: .language)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.language, forKey: .language)
        // Truncate `name` to 640 characters before encoding.
        try truncatedEncode(self.name, withContainer: &container, forKey: .name, upToLength: 640)

        try truncatedEncode(self.description, withContainer: &container, forKey: .description, upToLength: 100_000)
    }

    enum CodingKeys: String, CodingKey {
        case language = "lang"
        case name
        case description
    }
}

/// An enumuation that defines the value of a label.
///
/// - Note: According to the AT Protocol specifications: "Strings which describe the label in the UI, localized into a specific language."
///
/// - SeeAlso: This is based on the [`com.atproto.label.defs`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/label/defs.json
public enum LabelValue: String, Codable {
    case hide = "!hide"
    case noPromote = "!no-promote"
    case warn = "!warn"
    case noUnauthenticated = "!no-unauthenticated"
    case dmcaViolation = "dmca-violation"
    case doxxing
    case porn
    case sexual
    case nudity
    case nsfl
    case gore
}
