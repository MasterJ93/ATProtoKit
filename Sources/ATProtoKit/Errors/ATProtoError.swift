//
//  ATProtoError.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

public enum ATProtoError: Error, Decodable {
    case badRequest(message: String) // Error 400
    case unauthorized(mesage: String) // Error 401
    case forbidden(message: String) // Error 403
    case notFound(message: String) // Error 404
    case payloadTooLarge(message: String) // Error 413
    case tooManyRequests(message: String) // Error 429
    case internalServerError(message: String) // Error 500
    case notImplemented(message: String) // Error 501
    case badGateway(message: String) // Error 502
    case serviceUnavailable(message: String) // Error 503
    case gatewayTimeout(message: String) // Error 504
    case unknown(message: String) // Unknown Error

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let errorType = try container.decode(String.self, forKey: .error)
        let message = try container.decode(String.self, forKey: .message)

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
                "DuplicateCreate",
                "TokenRequired":
                self = .badRequest(message: message)
            case "InternalServerError":
                self = .internalServerError(message: message)
            default:
                self = .unknown(message: message)
        }
    }

    enum CodingKeys: String, CodingKey {
        case error
        case message
    }
}
