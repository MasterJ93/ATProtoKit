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
public enum ATAPIError: ATProtoError {

    /// Represents a bad request error (HTTP 400) with an associated message.
    ///
    /// - Parameter error: The error name and message.
    case badRequest(error: APIClientService.ATHTTPResponseError) // Error 400

    /// Represents an unauthorized error (HTTP 401) with an associated message and HTTP header.
    ///
    /// - Parameters:
    ///   - error: The error name and message.
    ///   - wwwAuthenticate: The value for the `WWW-Authenticate` header. Optional.
    case unauthorized(error: APIClientService.ATHTTPResponseError, wwwAuthenticate: String?)

    /// Represents a forbidden error (HTTP 403) with an associated message.
    ///
    /// - Parameter error: The error name and message.
    case forbidden(error: APIClientService.ATHTTPResponseError)

    /// Represents a not found error (HTTP 404) with an associated message.
    ///
    /// - Parameter error: The error name and message.
    case notFound(error: APIClientService.ATHTTPResponseError)

    /// Represents a method not allowed error (HTTP 405) with an associated message.
    ///
    /// - Parameter error: The error name and message.
    case methodNotAllowed(error: APIClientService.ATHTTPResponseError)

    /// Represents a payload too large error (HTTP 413) with an associated message.
    ///
    /// - Parameter error: The error name and message.
    case payloadTooLarge(error: APIClientService.ATHTTPResponseError)

    /// Represents an upgrade required error (HTTP 426) with an associated message.
    ///
    /// - Parameter error: The error name and message.
    case upgradeRequired(error: APIClientService.ATHTTPResponseError)

    /// Represents a too many requests error (HTTP 429) with an associated message and HTTP header.
    ///
    /// - Parameters:
    ///   - error: The error name and message.
    ///   - retryAfter: The value for the `ratelimit-reset` header. Optional.
    case tooManyRequests(error: APIClientService.ATHTTPResponseError, retryAfter: TimeInterval?)

    /// Represents an internal server error (HTTP 500) with an associated message.
    ///
    /// - Parameter error: The error name and message.
    case internalServerError(error: APIClientService.ATHTTPResponseError)

    /// Represents a method not implemented error (HTTP 501) with an associated message.
    ///
    /// - Parameter error: The error name and message.
    case methodNotImplemented(error: APIClientService.ATHTTPResponseError)

    /// Represents a bad gateway error (HTTP 502) with an associated message.
    case badGateway

    /// Represents a service unavailable error (HTTP 503) with an associated message.
    case serviceUnavailable

    /// Represents a gateway timeout error (HTTP 504) with an associated message.
    case gatewayTimeout

    /// Represents an unknown error with an associated message.
    ///
    /// - Parameters:
    ///   - error: The message received along side the error. Optional.
    ///   - errorCode: The error code number Optional.
    ///   - errorData: The raw JSON object of the error. Optional.
    ///   - httpHeaders: The raw headers the come with the response. Optional.
    case unknown(error: String?, errorCode: Int? = nil, errorData: Data? = nil, httpHeaders: [String : String]? = nil)
}

extension ATProtoBluesky {

    /// An error type related to ``ATProtoBluesky``-related issues.
    public enum ATProtoBlueskyError: Decodable, ATProtoError {

        /// The post record could not be found.
        ///
        /// - Parameter message: The message of the error.
        case postNotFound(message: String)

        /// The reply reference could not be validated.
        ///
        /// - Parameter message: The message of the error.
        case invalidReplyReference(message: String)
    }

    /// An error type specifically related to Bluesky (either before or after interacting with
    /// the service).
    public enum ATBlueskyError: ATProtoError {

        /// The image used is too large.
        case imageTooLarge
    }
}

/// An error type related to ``ATLinkBuilder``-related issues.
public enum ATLinkBuilderError: Decodable, ATProtoError {

    /// The URL was invalid.
    ///
    /// - Parameter message: The message of the error.
    case invalidURL(message: String)

    /// The server or website had a bad response.
    ///
    /// - Parameter message: The message of the error.
    case badServerResponse(message: String)

    /// An unknown error has occured.
    ///
    /// - Parameter message: The message of the error.
    case unknownError(message: String)
}

/// An error type related to a failed upload job.
/// 
/// This would typically be used in a job status.
public enum ATJobStatusError: Decodable, ATProtoError {

    /// The job failed.
    ///
    /// The error code for this will be 409.
    ///
    /// - Parameter error: A job state, containing a filed up error and message.
    case failedJob(error: AppBskyLexicon.Video.JobStatusDefinition)

    /// The video can't be uploaded because the user account has used up their upload limit
    /// for today.
    ///
    /// - Parameter message: The message for the error.
    case videoLimitExceeded(message: String)

    /// The video can't be uploaded because the user account either has the ability to upload
    /// videos disabld or because they have been banned from doing so.
    ///
    /// - Parameter message: The message for the error.
    case permissionToUploadVideosDenied(message: String)
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

    /// The PDS field is empty.
    case emptyPDSURL

    /// The record may be invalid.
    case invalidRecord
}

extension APIClientService {

    /// An error type related to issues surrounding HTTP requests.
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

    /// An error type related to issues surrounding HTTP responses.
    public struct ATHTTPResponseError: Decodable, ATProtoError {

        /// The name of the error.
        public let error: String

        /// The message for the error.
        public let message: String
    }
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

extension ATProtocolConfiguration {

    /// An error type related to ``ATProtocolConfiguration``.
    public enum ATProtocolConfigurationError: ATProtoError {

        /// No token was found.
        ///
        /// - Parameter message: The message for the error.
        case noSessionToken(message: String)

        /// The access and refresh tokens have both expired.
        ///
        /// - Parameter message: The message for the error.
        case tokensExpired(message: String)
    }
}

/// An error type related to CBOR processing issues.
public enum CBORProcessingError: Error {
    
    /// The CBOR string can't be decoded.
    case cannotDecode
}
