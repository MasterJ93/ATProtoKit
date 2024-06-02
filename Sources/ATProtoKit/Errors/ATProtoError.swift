//
//  ATProtoError.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

/// The base exception class for ATProtoKit.
public protocol ATProtoError: Error {}

/// The base exception class for ATProtoKit's API requests.
public enum ATAPIError: ATProtoError, Decodable {

    /// Represents a bad request error (HTTP 400) with an associated message.
    /// - Parameter message: The message received along side the error.
    case badRequest(message: String?) // Error 400

    /// Represents an unauthorized error (HTTP 401) with an associated message.
    /// - Parameter message: The message received along side the error.
    case unauthorized(message: String?)

    /// Represents a forbidden error (HTTP 403) with an associated message.
    /// - Parameter message: The message received along side the error.
    case forbidden(message: String?)

    /// Represents a method not allowed error (HTTP 405) with an associated message.
    /// - Parameter message: The message received along side the error.
    case methodNotAllowed(message: String?)

    /// Represents a payload too large error (HTTP 413) with an associated message.
    /// - Parameter message: The message received along side the error.
    case payloadTooLarge(message: String?)

    /// Represents an upgrade required error (HTTP 426) with an associated message.
    /// - Parameter message: The message received along side the error.
    case upgradeRequired(message: String?)

    /// Represents a too many requests error (HTTP 429) with an associated message.
    /// - Parameter message: The message received along side the error.
    case tooManyRequests(message: String?)

    /// Represents an internal server error (HTTP 500) with an associated message.
    /// - Parameter message: The message received along side the error.
    case internalServerError(message: String?)

    /// Represents a method not implemented error (HTTP 501) with an associated message.
    /// - Parameter message: The message received along side the error.
    case methodNotImplemented(message: String?)

    /// Represents a bad gateway error (HTTP 502) with an associated message.
    /// - Parameter message: The message received along side the error.
    case badGateway(message: String?)

    /// Represents a service unavailable error (HTTP 503) with an associated message.
    /// - Parameter message: The message received along side the error.
    case serviceUnavailable(message: String?)

    /// Represents a gateway timeout error (HTTP 504) with an associated message.
    /// - Parameter message: The message received along side the error.
    case gatewayTimeout(message: String?)

    /// Represents an unknown error with an associated message.
    /// - Parameter message: The message received along side the error.
    case unknown(message: String?)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let errorType = try container.decode(String.self, forKey: .error)
        let message = try container.decodeIfPresent(String.self, forKey: .message)

        switch errorType {
            case 
                "InvalidRequest",
                "ExpiredToken",
                "InvalidToken",
                "BlockedActor",
                "BlockedByActor",
                "UnknownFeed",
                "UnknownList",
                "NotFound",
                "BadQueryString",
                "SubjectHasAction",
                "RecordNotFound",
                "RepoNotFound",
                "InvalidSwap",
                "AccountNotFound",
                "InvalidEmail",
                "InvalidHandle",
                "InvalidPassword",
                "InvalidInviteCode",
                "HandleNotAvailable",
                "UnsupportedDomain",
                "UnresolvableDid",
                "IncompatibleDidDoc",
                "AccountTakedown",
                "RepoTakendown",
                "RepoDeactivated",
                "RepoSuspended",
                "DuplicateCreate",
                "TokenRequired",
                "FutureCursor",
                "ConsumerTooSlow",
                "AuthFactorTokenRequired":
                self = .badRequest(message: message)
            case "Unauthorized":
                self = .unauthorized(message: message)
            case "Forbidden":
                self = .forbidden(message: message)
            case "MethodNotAllowed":
                self = .methodNotAllowed(message: message)
            case "PayloadTooLarge":
                self = .payloadTooLarge(message: message)
            case "UpgradeRequired":
                self = .upgradeRequired(message: message)
            case "TooManyRequests":
                self = .tooManyRequests(message: message)
            case "InternalServerError":
                self = .internalServerError(message: message)
            case "MethodNotImplemented":
                self = .methodNotImplemented(message: message)
            case "BadGateway":
                self = .badGateway(message: message)
            case "ServiceUnavailable":
                self = .serviceUnavailable(message: message)
            case "GatewayTimeout":
                self = .gatewayTimeout(message: message)
            default:
                self = .unknown(message: message)
        }
    }

    enum CodingKeys: String, CodingKey {
        case error
        case message
    }
}

/// An error type related to issues surrounding preparing a request to be sent.
public enum ATRequestPrepareError: ATProtoError {

    /// The format of the object is incorrect.
    case invalidFormat

    /// The requestURL may be incorrect (either the endpoint itself or the URL of the
    /// Personal Data Server (PDS)).
    case invalidRequestURL

    /// The hostname's URL may be incorrect.
    case invalidHostnameURL

    /// There's no valid or active session in the instance.
    ///
    /// Authentication is required for methods that need it.
    case missingActiveSession

    /// This PDS will not work.
    case invalidPDS

    /// The record may be invalid.
    case invalidRecord
}

/// An error type related to issues surrounding HTTP requests and responses.
public enum ATHTTPRequestError: ATProtoError {
    /// Unable to encode the request body.
    case unableToEncodeRequestBody

    /// Failed to construct URL with the given parameters.
    case failedToConstructURLWithParameters

    /// Failed to decode HTML content.
    case failedToDecodeHTML

    /// Error encountered while getting the response from the server.
    case errorGettingResponse

    /// The response may be invalid.
    case invalidResponse
}

/// An error type specifically related to Bluesky (either before or after interacting with
/// the service).
public enum ATBlueskyError: ATProtoError {

    /// The image used is too large.
    case imageTooLarge
}

/// An error type related to issues surrounding
public enum ATEventStreamError: ATProtoError {

    /// The endpoint URL used may not be correct.
    case invalidEndpoint
    
    /// The data length is not sufficient.
    case insufficientDataLength
}

/// An error type containing WebSocket frames for error messages.
public struct WebSocketFrameMessageError: Decodable, ATProtoError {
    
    /// The type of error given.
    public let error: String
    
    /// The message contained with the error. Optional.
    public let message: String?
}

/// An error type related to CBOR processing issues.
public enum CBORProcessingError: Error {
    
    /// The CBOR string can't be decoded.
    case cannotDecode
}

/// An error type related to ``ATImageProcessable``.
public enum ATImageProcessingError: ATProtoError {

    /// The image's file size can't be lowered any further to fit the target file size.
    case unableToResizeImage
}
