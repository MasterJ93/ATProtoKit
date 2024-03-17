//
//  AtprotoTempCheckSignupQueue.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

/// The main data model definition for the output of retrieving information about the sign up queue.
///
/// - Important: The lexicon associated with this model may be removed at any time. This may not work.
///
/// - Note: According to the AT Protocol specifications: "Check accounts location in signup queue."
///
/// - SeeAlso: This is based on the [`com.atproto.temp.checkSignupQueue`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/checkSignupQueue.json
public struct TempCheckSignupQueueOutput: Codable {
    /// Indicates whether the user with the queried username has been activated.
    public let isActivated: Bool
    /// The user's place in queue. Optional.
    public let placeInQueue: Int?
    /// The estimated amount of time before the user can use the service (in minutes). Optional.
    public let estimatedTimeinMinutes: Int
}
