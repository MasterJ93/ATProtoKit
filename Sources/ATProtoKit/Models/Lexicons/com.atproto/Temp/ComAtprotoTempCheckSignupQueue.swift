//
//  ComAtprotoTempCheckSignupQueue.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


extension ComAtprotoLexicon.Temp {

    /// An output model for etrieving information about the sign up queue.
    ///
    /// - Important: The lexicon associated with this model may be removed at any time. This may
    /// not work.
    ///
    /// - Note: According to the AT Protocol specifications: "Check accounts location in
    /// signup queue."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.temp.checkSignupQueue`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/temp/checkSignupQueue.json
    public struct CheckSignupQueueOutput: Sendable, Codable {

        /// Indicates whether the user with the queried username has been activated.
        public let isActivated: Bool

        /// The user's place in queue. Optional.
        public let placeInQueue: Int?

        /// The estimated amount of time before the user can use the service
        /// (in minutes). Optional.
        public let estimatedTimeinMinutes: Int

        enum CodingKeys: String, CodingKey {
            case isActivated = "activated"
            case placeInQueue = "placeInQueue"
            case estimatedTimeinMinutes = "estimatedTimeMs"
        }
    }
}
