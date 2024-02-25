//
//  AtprotoServerCheckAccountStatus.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-23.
//

import Foundation

/// A data model definition for the output of checking the user's account status.
///
/// - Note: According to the AT Protocol specifications: "Returns the status of an account, especially as pertaining to import or recovery. Can be called many times over the course of an account migration. Requires auth and can only be called pertaining to oneself."
///
/// - SeeAlso: This is based on the [`com.atproto.server.checkAccountStatus`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/checkAccountStatus.json
public struct ServerCheckAccountStatusOutput: Codable {
    /// Indicates whether the user's account has been activated.
    public let isActivated: Bool
    /// Indicates whether the user's account has a valid ID.
    public let isValidID: Bool
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are needed in order to fully understand the this item.
    public let repositoryCommit: String
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are needed in order to fully understand the this item.
    public let repositoryRev: String
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are needed in order to fully understand the this item.
    public let repositoryBlocks: Int
    /// The number of indexed records in the user's account.
    public let indexedRecords: Int
    /// - Important: The item associated with this property is undocumented in the AT Protocol specifications. The documentation here is based on:\
    ///   \* **For items with some inferable context from property names or references**: its best interpretation, though not with full certainty.\
    ///   \* **For items without enough context for even an educated guess**: a direct acknowledgment of their undocumented status.\
    ///   Clarifications from Bluesky are needed in order to fully understand the this item.
    public let privateStateValues: Int
    /// The expected number of blobs in the user's account.
    public let expectedBlobs: Int
    /// The number of blobs imported into the user's account.
    public let importedBlobs: Int

    enum CodingKeys: String, CodingKey {
        case isActivated = "activated"
        case isValidID = "validID"
        case repositoryCommit = "repoCommit"
        case repositoryRev = "repoRev"
        case repositoryBlocks = "repoBlocks"
        case indexedRecords
        case privateStateValues
        case expectedBlobs
        case importedBlobs
    }
}
