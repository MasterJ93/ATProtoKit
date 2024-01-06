//
//  ATProtoError.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

public enum ATProtoError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case payloadTooLarge
    case tooManyRequests
    case internalServerError
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    
    init?(statusCode: Int) {
        switch statusCode {
            case 400: self = .badRequest
            case 401: self = .unauthorized
            case 403: self = .forbidden
            case 404: self = .notFound
            case 413: self = .payloadTooLarge
            case 429: self = .tooManyRequests
            case 500: self = .internalServerError
            case 501: self = .notImplemented
            case 502: self = .badGateway
            case 503: self = .serviceUnavailable
            case 504: self = .gatewayTimeout
            default: return nil
        }
    }
}
