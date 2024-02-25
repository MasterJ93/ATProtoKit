//
//  AtprotoModerationDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

/// A data model for the definition of the moderator's reason for reporting.
///
/// - SeeAlso: This is based on the [`com.atproto.moderation.defs`][github] lexicon.
///
/// - Important: The item associated with this enum is undocumented in the AT Protocol specifications. The documentation here is based on:\
///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
///   Clarifications from Bluesky are needed in order to fully understand this item.
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/defs.json
public enum ModerationReasonType: String, Codable {
    /// Indicates spam as the reason.
    ///
    /// - Note: According to the AT Protocol specifications: "Spam: frequent unwanted promotion, replies, mentions."
    case reasonSpam
    /// Indicates a rule violation as the reason.
    ///
    /// - Note: According to the AT Protocol specifications: "Direct violation of server rules, laws, terms of service."
    case reasonViolation
    /// Indicates misleading content as the reason.
    ///
    /// - Note: According to the AT Protocol specifications: "Misleading identity, affiliation, or content."
    case reasonMisleading
    /// Indicates mislabeled/unwanted sexual content as the reason.
    ///
    /// - Note: According to the AT Protocol specifications: "Unwanted or mislabeled sexual content."
    case reasonSexual
    /// Indicates rude behavior as the reason.
    ///
    /// - Note: According to the AT Protocol specifications: "Rude, harassing, explicit, or otherwise unwelcoming behavior."
    case reasonRude
    /// Indicates a reason not otherwise specified.
    ///
    /// - Note: According to the AT Protocol specifications: "Other: reports not falling under another report category."
    case reasonOther
    /// Indicates an appeal to a previous moderation ruling as the reason.
    ///
    /// - Note: According to the AT Protocol specifications: "Appeal: appeal a previously taken moderation action."
    case reasonAppeal
}
