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

/// An error type related to issues with decentralized identifiers (DIDs).
public enum ATDIDError: ATProtoError {

    /// There are characters in the decentralized identifier (DID) that are not part of the
    /// range of allowed characters.
    ///
    /// A DID can only contain characters from the ASCII standard, underscores (\_), periods (.),
    /// colons (:), percent signs (%), and hypens (-).
    case disallowedCharacters

    /// The decentralized identifier (DID) lacks the minimum required segments.
    ///
    /// A DID must have three segments: the prefix, the method, and any method-specific content.
    case notEnoughSegments

    /// The decentralized identifier (DID) lacks the "did:" prefix.
    case noValidPrefix

    /// The method segment of the decentralized identifier (DID) is not all lowercased.
    case didMethodNotLowercased

    /// A colon (:) or percentage symbol (%) was found at the end of the last segment.
    case invalidSuffixCharacter

    /// The decentralized identifier (DID) has a length that's higher than 2,048 characters.
    case tooLong

    /// The regular expression could not validate the given decentralized identifier (DID).
    case failedToValidateViaRegex
}

/// An error type related to issues with handles.
public enum ATHandleError: ATProtoError {

    /// There are characters in the handle that are not part of the range of allowed characters.
    ///
    /// A handle can only contain letters and numbers from the ASCII standard, periods (.),
    /// and hypens (-).
    case disallowedCharacters

    /// The handle has a length that's higher than 253 characters.
    case tooLong

    /// The handle doesn't have enough segments to be valid.
    ///
    /// Handles must have at least two segments: the domain name and the TLD.
    case notEnoughSegments

    /// One of the segments in the handle is empty.
    case emptySegment

    /// One of the segments in the handle has too many characters.
    ///
    /// Handle segments can have a maximum of 63 characters.
    case segmentTooLong

    /// One of the segments has a hypen (-) as the first or last character.
    case hyphenFoundAtSegmentEnds

    /// The TLD segment contains a character other than a latin letter.
    case nonLatinLetterFoundInTLDSegment

    /// The regular expression could not validate the given handle.
    case failedToValidateViaRegex
}

/// An error type related to issues with Namespaced Identifiers (NSIDs).
public enum ATNSIDError: ATProtoError {

    /// There are characters in the Namespaced Identifier (NSID) that are not part of the
    /// ASCII standard.
    case disallowedASCIICharacters

    /// The Namespaced Identifier (NSID) has a length that's higher than 317 characters.
    case tooLong

    /// The Namespaced Identifier (NSID) doesn't have enough segments to be valid.
    ///
    /// NSIDs must have at least three segments: an authority segment (which consists of
    /// two segments) and the name/subdomain segment.
    case notEnoughSegments

    /// One of the segments in the Namespaced Identifier (NSID) is empty.
    case emptySegment

    /// One of the segments in the Namespaced Identifier (NSID) has too many characters.
    ///
    /// NSID segments can have a maximum of 63 characters.
    case segmentTooLong

    /// One of the segments has a hypen (-) as the first or last character.
    case hyphenFoundAtSegmentEnds

    /// A number was found in the beginning of the first segment.
    case numberFoundinFirstSegment

    /// The name segment contains characters other than latin letters.
    case nonLatinLetterFoundInNameSegment

    /// The regular expression could not validate the given Namespaced Identifier (NSID).
    case failedToValidateViaRegex
}

/// An error type related to issues with AT URIs.
public enum ATURIError: ATProtoError {

    /// The URI is invalid.
    case invalidURI

    /// The URI is undefined.
    case undefinedURI

    /// There are than one hashtags in the URI.
    case tooManyHashtags

    /// There are characters in the URI that are not part of the
    /// ASCII standard.
    case disallowedASCIICharacters

    /// The AT URI must contain `at://` as its first segment.
    case missingPrefix

    /// The URI doesn't have enough segments to be valid.
    ///
    /// AT URIs must have at least three segments: the `at://` prefix, a method, and authority.
    case notEnoughSegments

    /// The URI doesn't contain a valid decentralized identifier (DID) or handle.
    case invalidAuthority

    /// The AT URI cannot have a slash after the authority segment without a path segment.
    case slashWithoutPathSegmentFound

    /// The URI requires a first path segment (if supplied) to have a valid
    /// Namespaced Identifier (NSID).
    case invalidNSID

    /// The AT URI cannot have a slash after the collection unless a record key is provided.
    case slashAfterCollectionWithoutRecordKey

    /// AT URI path can have at most two parts, and no trailing slash
    case tooManySegments

    /// AT URI fragment must be non-empty and start with slash.
    case invalidOrEmptyFragment

    /// There are characters in the fragment segment that are not part of the
    /// ASCII standard.
    case disallowedASCIICharactersInFragment

    /// The AT URI has a length that's higher than 8,192 characters.
    case tooLong

    /// The regular expression could not validate the given AT URI.
    case failedToValidateViaRegex
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
