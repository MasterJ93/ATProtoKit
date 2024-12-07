//
//  ComAtprotoServerCreateAccount.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Server {

    /// A request body model for creating an account.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an account. Implemented
    /// by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createAccount.json
    public struct CreateAccountRequestBody: Sendable, Codable {

        /// The email of the user. Optional.
        public var email: String?

        /// The handle the user wishes to use.
        ///
        /// - Note: According to the AT Protocol specifications: "Requested handle for
        /// the account."
        public let handle: String

        /// A decentralized identifier (DID) that has existed before and will be used to be
        /// imported to the new account. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Pre-existing atproto DID, being
        /// imported to a new account."
        public var existingDID: String?

        /// The invite code for the user. Optional.
        ///
        /// - Note: Invite codes are no longer used in Bluesky. This is left here for legacy
        /// purposes, as well as for any federated networks that may use this feature.
        public var inviteCode: String?

        /// A verification code.
        public var verificationCode: String?

        /// A code that has come from a text message in the user's phone. Optional.
        public var verificationPhone: String?

        /// The password the user will use for the account. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Initial account password.
        /// May need to meet instance-specific password strength requirements."
        public var password: String?

        /// DID PLC rotation key (aka, recovery key) to be included in PLC
        /// creation operation. Optional.
        ///
        /// - Note: The above documentation is taken directly from the AT Protocol apecifications.
        public var recoveryKey: String?

        /// A signed DID PLC operation to be submitted as part of importing an existing account
        /// to this instance. NOTE: this optional field may be updated when full account migration
        /// is implemented. Optional.
        ///
        /// - Note: The above documentation is taken directly from the AT Protocol apecifications.
        public var plcOp: UnknownType?

        public init(email: String?, handle: String, existingDID: String?, inviteCode: String?, verificationCode: String?, verificationPhone: String?,
                    password: String?, recoveryKey: String?, plcOp: UnknownType?) {
            self.email = email
            self.handle = handle
            self.existingDID = existingDID
            self.inviteCode = inviteCode
            self.verificationCode = verificationCode
            self.verificationPhone = verificationCode
            self.password = password
            self.recoveryKey = recoveryKey
            self.plcOp = plcOp
        }

        enum CodingKeys: String, CodingKey {
            case email
            case handle
            case existingDID = "did"
            case inviteCode
            case verificationCode
            case verificationPhone
            case password
            case recoveryKey
            case plcOp
        }
    }

    /// An output model for creating an account.
    ///
    /// - Note: According to the AT Protocol specifications: "Create an account. Implemented
    /// by PDS."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.server.createAccount`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/createAccount.json
    public struct CreateAccountOutput: Sendable, Codable {

        /// The access token of the user account.
        public let accessToken: String

        /// The refresh token of the user account.
        public let refreshToken: String

        /// The handle of the user account.
        public let handle: String

        /// The decentralized identifier (DID), serving as a persistent and long-term account
        /// identifier according to the W3C standard.
        ///
        /// - Note: According to the AT Protocol specifications: "The DID of the new account."
        public let did: String

        /// The DID document associated with the user, which contains AT Protocol-specific
        /// information. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Complete DID document."
        public let didDocument: UnknownType?

        enum CodingKeys: String, CodingKey {
            case accessToken = "accessJwt"
            case refreshToken = "refreshJwt"
            case handle
            case did
            case didDocument = "didDoc"
        }
    }
}
