//
//  ComAtprotoIdentityRequestPlcOperationSignature.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation

extension ComAtprotoLexicon.Identity {

    /// A request body model for requesting a signed PLC operation.
    ///
    /// - Note: According to the AT Protocol specifications: "Request an email with a code to in
    /// order to request a signed PLC operation. Requires Auth."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.requestPlcOperationSignature`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/requestPlcOperationSignature.json
    public struct RequestPlcOperationSignatureRequestBody: Sendable, Codable {}
}
