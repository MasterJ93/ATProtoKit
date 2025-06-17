//
//  SessionToken.swift
//
//
//  Created by Christopher Jr Riley on 2025-01-11.
//

import Foundation

/// A decoded session token.
///
/// Otherwise known as a JSON Web Token (JWT).
public struct SessionToken: Sendable, Encodable {

    /// The header of the session token.
    ///
    /// This includes the algorithm method used to validate the given token, as well as
    /// the "type" value.
    public let header: Header

    /// The payload of the token.
    ///
    /// This includes the what the token will let the user use during the session, the
    /// decentralized identifier (DID) that can use the session, the dates and times of its
    /// creation and expiry, and Personal Data Server (PDS) the session is located at.
    public let payload: Payload

    /// The signature to validate the token.
    ///
    /// - Note: To validate the token, you need to use the algorithm specified by the
    /// token's ``SessionTokenAlgorithm`` value.
    ///
    /// - Note: According to the AT Protocol specifications: "Base64url-encoded signature using
    /// the account DID's signing key."
    public let signature: Data?

    /// Decodes a session token, then initializes a new instance with the results.
    public init(sessionToken: String) throws {
        let decodedJWT = try SessionToken.decodeJWT(sessionToken)

        self.header = decodedJWT.header
        self.payload = decodedJWT.payload
        self.signature = decodedJWT.signature
    }

    /// Decodes a Base64 URL-encoded string into a `Data` object.
    ///
    /// - Parameter base64: The Base64 URL-encoded string to decode.
    /// - Returns: A `Data` object if the decoding is successful; otherwise, `nil` if the string is invalid.
    private static func decodeBase64(_ base64: String) -> Data? {
        var base64 = base64
        while base64.count % 4 != 0 { base64.append("=") }
        return Data(base64Encoded: base64.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/"))
    }

    /// Decodes a session token into its header, payload, and signature components.
    ///
    /// The token is split into three segments: the header JSON, the payload JSON, and
    /// the signature. Each segment is Base64 URL-encoded and will be decoded and parsed to
    /// extract the corresponding components.
    ///
    /// - Parameter jwt: The JWT string to decode.
    /// - Throws: A `SessionTokenError` if:
    ///   - The token does not have exactly three segments.
    ///   - Any of the segments cannot be Base64-decoded.
    ///   - The header or payload cannot be parsed into their respective types.
    /// - Returns: A tuple containing the decoded header, payload, and signature values.
    ///
    /// - Throws: ``SessionTokenError`` if the token is invalid or there are missing segments.
    private static func decodeJWT(_ jwt: String) throws -> (header: Header, payload: Payload, signature: Data) {
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else {
            throw SessionTokenError.invalidSessionToken(message: "Invalid token.")
        }

        guard let headerData = SessionToken.decodeBase64(String(segments[0])),
              let payloadData = SessionToken.decodeBase64(String(segments[1])),
              let signature = SessionToken.decodeBase64(String(segments[2])) else {
            throw SessionTokenError.invalidSessionToken(message: "Could not decode the token.")
        }

        do {
            let decoder = JSONDecoder()

            let header = try decoder.decode(Header.self, from: headerData)
            let payload = try decoder.decode(Payload.self, from: payloadData)
            return (header, payload, signature)
        } catch {
            throw SessionTokenError.invalidSessionToken(message: "Could not decode the token.")
        }
    }

    /// The header of the session token.
    ///
    /// This includes the algorithm method used to validate the given token, as well as
    /// the "type" value.
    public struct Header: Sendable, Codable {

        /// The type of
        ///
        /// - Note: According to the AT Protocol specifications: "Currently `JWT`, but intend to
        /// update to a more specific value."
        public let type: String

        /// The token's signing key.
        ///
        /// - Note: According to the AT Protocol specifications: "Indicates the signing key type
        /// (see Cryptography)."
        ///
        /// - SeeAlso: The [Cyptography][cyptography] section of the AT Protocol specifications.
        ///
        /// [cyptography]: https://atproto.com/specs/cryptography
        public let algorithm: String

        enum CodingKeys: String, CodingKey {
            case type = "typ"
            case algorithm = "alg"
        }
    }

    /// The payload of the token.
    ///
    /// This includes the what the token will let the user use during the session, the
    /// decentralized identifier (DID) that can use the session, the dates and times of its
    /// creation and expiry, and Personal Data Server (PDS) the session is located at.
    public struct Payload: Sendable, Codable {

        /// The decentralized identifier (DID) for which the request is being made. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Account DID that the request is
        /// being sent on behalf of. This may include a suffix service identifier; see below."
        public let issuer: String?

        /// The decentralized identifier (DID) of the subject the session token is given to.
        /// Optional.
        public let subjectDID: String?

        /// The decentralized identifier (DID) associated with the service to which the request is
        /// being sent to.
        ///
        /// - Note: According to the AT Protocol specifications: "Service DID associated with the
        /// service that the request is being sent to."
        public let audience: String

        /// The date and time the token expires.
        ///
        /// - Note: According to the AT Protocol specifications: "oken expiration time, as a
        /// UNIX timestamp with seconds precision. Should be a short time window, as revocation is
        /// not implemented. 60 seconds is a good token lifetime."
        public let expiresAt: Date

        /// The date and time the token was created.
        ///
        /// - Note: According to the AT Protocol specifications: "Token creation time, as a
        /// UNIX timestamp with seconds precision."
        public let issuedAt: Date

        /// The lexicon method that the token will only the user account to use within the session.
        ///
        /// - Note: According to the AT Protocol specifications: "hort for "lexicon method".
        /// NSID syntax. Indicates the endpoint that this token authorizes. Servers must always
        /// validate this field if included, and should require it for
        /// security-sensitive operations. May become required in the future."
        public let lexiconMethod: String?

        /// A random string nonce. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "Unique random string nonce.
        /// May be used by receiving services to prevent reuse of token and replay attacks."
        public let nonce: String?

        /// The scope of token. Optional.
        ///
        /// This will only appear if ``SessionToken/Payload-swift.struct/issuer`` is empty.
        public let scope: String?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.issuer = try container.decodeIfPresent(String.self, forKey: .issuer)
            self.subjectDID = try container.decodeIfPresent(String.self, forKey: .subjectDID)
            self.audience = try container.decode(String.self, forKey: .audience)

            // Convert the UNIX Epoch for expiresAt into a date.
            let expiresAtTimestamp = try container.decode(Double.self, forKey: .expiresAt)
            self.expiresAt = Date(timeIntervalSince1970: expiresAtTimestamp)

            // Convert the UNIX Epoch for issuedAt into a date.
            let issuedAtTimestamp = try container.decode(Double.self, forKey: .issuedAt)
            self.issuedAt = Date(timeIntervalSince1970: issuedAtTimestamp)

            self.lexiconMethod = try container.decodeIfPresent(String.self, forKey: .lexiconMethod)
            self.nonce = try container.decodeIfPresent(String.self, forKey: .nonce)
            self.scope = try container.decodeIfPresent(String.self, forKey: .scope)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encodeIfPresent(self.issuer, forKey: .issuer)
            try container.encodeIfPresent(self.subjectDID, forKey: .subjectDID)
            try container.encode(self.audience, forKey: .audience)
            try container.encode(self.expiresAt, forKey: .expiresAt)

            let expiresAtTimestamp = self.expiresAt.timeIntervalSince1970
            try container.encode(expiresAtTimestamp, forKey: .expiresAt)

            let issuedAtTimestamp = self.issuedAt.timeIntervalSince1970
            try container.encode(issuedAtTimestamp, forKey: .issuedAt)

            try container.encodeIfPresent(self.lexiconMethod, forKey: .lexiconMethod)
            try container.encodeIfPresent(self.nonce, forKey: .nonce)
            try container.encodeIfPresent(self.scope, forKey: .scope)
        }

        enum CodingKeys: String, CodingKey {
            case issuer = "iss"
            case subjectDID = "sub"
            case audience = "aud"
            case expiresAt = "exp"
            case issuedAt = "iat"
            case lexiconMethod = "lxm"
            case nonce = "jti"
            case scope
        }
    }

    /// Errors related to session tokens.
    public enum SessionTokenError: Error {

        /// The session token is invalid.
        ///
        /// - Parameter message: The message of the error.
        case invalidSessionToken(message: String)

        /// The token's header is invalid.
        ///
        /// - Parameter message: The message of the error.
        case invalidHeader(message: String)

        /// The token's header is missing.
        ///
        /// - Parameter message: The message of the error.
        case missingHeader(message: String)

        /// The token's payload is invalid.
        /// - Parameter message: The message of the error.
        case invalidPayload(message: String)

        /// The token's payload is missing.
        ///
        /// - Parameter message: The message of the error.
        case missingPayload(message: String)

        /// The token's signature is invalid.
        ///
        /// - Parameter message: The message of the error.
        case invalidSignature(message: String)

        /// The token's signature is invalid.
        ///
        /// - Parameter message: The message of the error.
        case missingSignature(message: String)
    }

    /// The token's signing key type.
    ///
    /// - Note: According to the AT Protocol specifications: "Indicates the signing key type
    /// (see Cryptography)."
    ///
    /// - SeeAlso: The [Cyptography][cyptography] section of the AT Protocol specifications.
    ///
    /// [cyptography]: https://atproto.com/specs/cryptography
    public enum SessionTokenAlgorithm: String, Codable {

        /// The "p256" elliptic curve.
        case ES256

        /// The "k265" elliptic curve.
        case ES256K
    }
}
