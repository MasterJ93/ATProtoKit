//
//  ComAtprotoIdentitySignPLCOperation.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Identity {

    /// A request body model for signing a PLC operation to a DID document.
    ///
    /// - Note: According to the AT Protocol specifications: "Signs a PLC operation to update some
    /// value(s) in the requesting DID's document."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.signPlcOperation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/signPlcOperation.json
    public struct SignPLCOperationRequestBody: Sendable, Codable {

        /// A token received from
        /// ``ATProtoKit/ATProtoKit/requestPLCOperationSignature()``. Optional.
        ///
        /// - Note: According to the AT Protocol specifications: "A token received
        /// through com.atproto.identity.requestPlcOperationSignature"
        public let token: String?

        /// The rotation keys recommended to be added in the DID document. Optional.
        /// An array of aliases of the user account. Optional.
        /// - Important: To add a new rotation key, include all existing rotation keys with the new
        /// rotation key.
        ///
        /// - Important: To remove a rotation key, include all existing rotation keys except the
        /// rotation key being removed.
        public let rotationKeys: [String]?

        /// An array of aliases of the user account. Optional.
        /// - Important: To add a new alias, include all existing aliases with the new alias.
        ///
        /// - Important: To remove an alias, include all existing alias' except the alias being removed.
        public let alsoKnownAs: [String]?

        /// A dictionary of verification methods to inckude in the DID document. Optional.
        /// - Important: To add a new verification method, include all existing verification methods with the
        /// new verification method.
        ///
        /// - Important: To remove a verification method, include all existing verification methods except the
        /// verification method being removed.
        public let verificationMethods: [String: String]? //VerificationMethod?

        /// A dictionary of service endpoints to include in the DID document. Optional.
        /// - Important: To add a new service endpoint, include all existing service endpoints with the
        /// new service endpoint.
        ///
        /// - Important: To remove a service endpoint, include all existing service endpoints except the
        /// service endpoint being removed.
        public let services: [String: PLCOperationATService]? //ATService?
        
        public init(token: String?, rotationKeys: [String]?, alsoKnownAs: [String]?, verificationMethods: [String : String]?, services: [String : PLCOperationATService]?) {
            self.token = token
            self.rotationKeys = rotationKeys
            self.alsoKnownAs = alsoKnownAs
            self.verificationMethods = verificationMethods
            self.services = services
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(self.token, forKey: .token)
            try container.encodeIfPresent(self.rotationKeys, forKey: .rotationKeys)
            try container.encodeIfPresent(self.alsoKnownAs, forKey: .alsoKnownAs)
            try container.encodeIfPresent(self.verificationMethods, forKey: .verificationMethods)
            try container.encodeIfPresent(self.services, forKey: .services)
        }
        
        enum CodingKeys: String, CodingKey {
            case token
            case rotationKeys
            case alsoKnownAs
            case verificationMethods
            case services
        }
    }

    /// An output model for signing a PLC operation to a DID document.
    ///
    /// - Note: According to the AT Protocol specifications: "Signs a PLC operation to update some
    /// value(s) in the requesting DID's document."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.identity.signPlcOperation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/signPlcOperation.json
    public struct SignPLCOperationOutput: Sendable, Codable {

        /// A signed PLC operation.
        public let operation: SignedPLCOperation
    }
    
    /// Represents a service endpoint in a DID document in a PLC operation
    ///
    /// - SeeAlso: This is based on the PLC Directory [`CreatePlcOp`][plc].
    ///
    /// [plc]: https://web.plc.directory/api/redoc#operation/CreatePlcOp
    public struct PLCOperationATService: Sendable, Codable {

        /// The type of service.
        public let type: String

        /// The endpoint URL for the service, specifying the location of the service.
        public let serviceEndpointURI: String
        
        public init(type: String, serviceEndpointURI: String) {
            self.type = type
            self.serviceEndpointURI = serviceEndpointURI
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.type = try container.decode(String.self, forKey: .type)
            self.serviceEndpointURI = try container.decode(String.self, forKey: .serviceEndpointURI)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.type, forKey: .type)
            try container.encode(self.serviceEndpointURI, forKey: .serviceEndpointURI)
        }
        
        enum CodingKeys: String, CodingKey {
            case type
            case serviceEndpointURI = "endpoint"
        }
    }
    
    /// Represents a signed PLC operation response
    ///
    /// - Note: A signed PLC operation is returned in the response to calling
    /// [`com.atproto.identity.signPlcOperation`][github]
    ///
    /// - SeeAlso: This is based on the PLC Directory [`CreatePlcOp`][plc].
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/identity/signPlcOperation.json
    /// [plc]: https://web.plc.directory/api/redoc#operation/CreatePlcOp
    public struct SignedPLCOperation: Sendable, Codable {
        
        /// The PLC operation type
        public let type: String

        /// Ordered set (no duplicates) of cryptographic public keys in did:key format
        public let rotationKeys: [String]

        /// Map (object) of application-specific cryptographic public keys in did:key format
        public let verificationMethods: [String: String]

        /// Ordered set (no duplicates) of aliases and names for this account, in the form of URIs
        public let alsoKnownAs: [String]

        /// Map (object) of application-specific service endpoints for this account
        public let services: [String: PLCOperationATService]

        /// Strong reference (hash) of preceeding operation for this DID, in string CID format. Null for genesis operation
        public let prev: String
       
        /// Cryptographic signature of this object, with base64 string encoding
        public let sig: String
    }
}
