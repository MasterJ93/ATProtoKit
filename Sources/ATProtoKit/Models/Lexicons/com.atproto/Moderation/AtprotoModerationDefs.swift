//
//  AtprotoModerationDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-25.
//

import Foundation

public enum ModerationReasonType: String, Codable {
    /// Spam: frequent unwanted promotion, replies, mentions
    case reasonSpam

    /// Direct violation of server rules, laws, terms of service
    case reasonViolation

    /// Misleading identity, affiliation, or content
    case reasonMisleading

    /// Unwanted or mislabeled sexual content
    case reasonSexual

    /// Rude, harassing, explicit, or otherwise unwelcoming behavior
    case reasonRude

    /// Other: reports not falling under another report category
    case reasonOther

    /// Appeal: appeal a previously taken moderation action
    case reasonAppeal
}
