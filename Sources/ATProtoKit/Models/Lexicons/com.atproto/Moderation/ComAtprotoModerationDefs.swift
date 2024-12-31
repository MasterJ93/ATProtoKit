//
//  ComAtprotoModerationDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Moderation {

    /// A definition model for the types of reasons for the report.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/defs.json
    public enum ReasonTypeDefinition: String, Sendable, Codable {

        /// Indicates spam as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Spam: frequent unwanted
        /// promotion, replies, mentions."
        case spam = "reasonSpam"

        /// Indicates a rule violation as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Direct violation of server rules,
        /// laws, terms of service."
        case violation = "reasonViolation"

        /// Indicates misleading content as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Misleading identity,
        /// affiliation, or content."
        case misleading = "reasonMisleading"

        /// Indicates mislabeled/unwanted sexual content as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Unwanted or mislabeled
        /// sexual content."
        case sexual = "reasonSexual"

        /// Indicates rude behavior as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Rude, harassing, explicit, or
        /// otherwise unwelcoming behavior."
        case rude = "reasonRude"

        /// Indicates a reason not otherwise specified.
        ///
        /// - Note: According to the AT Protocol specifications: "Other: reports not falling under
        /// another report category."
        case other = "reasonOther"

        /// Indicates an appeal to a previous moderation ruling as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Appeal: appeal a previously taken
        /// moderation action."
        case appeal = "reasonAppeal"
    }
}
