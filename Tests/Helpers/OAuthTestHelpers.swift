//
//  OAuthTestHelpers.swift
//  ATProtoKitTests
//
//  Created by Christopher Jr Riley on 2026-08-17.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Testing
@testable import ATProtoKit

internal func requireAppPasswordCapabilities<Configuration>(_: Configuration.Type)
where Configuration: SessionConfiguration,
      Configuration: AppPasswordSessionManaging,
      Configuration: AppPasswordCredentialStoring,
      Configuration: AppPasswordAuthenticating,
      Configuration: ATAccountCreating,
      Configuration: UserSessionRegistryManaging {
}

internal func requireOAuthCapabilities<Configuration>(_: Configuration.Type)
where Configuration: SessionConfiguration,
      Configuration: OAuthSessionSynchronizing,
      Configuration: UserSessionRegistryManaging {
}

internal struct TestBody: Encodable, Sendable {
    internal let value: String
}

internal enum TestExecutorError: Error {
    case requestRecorded
}

internal func sessionResponseData() -> Data {
    return Data(#"{"handle":"session.example","did":"did:plc:session","active":true}"#.utf8)
}

internal final class HeaderSessionConfiguration: SessionConfiguration {
    private let accessToken: String

    internal let pdsURL: String
    internal let configuration: URLSessionConfiguration
    internal let instanceUUID: UUID

    internal init(
        pdsURL: String,
        instanceUUID: UUID,
        accessToken: String = "app-password-access-token"
    ) {
        self.pdsURL = pdsURL
        self.configuration = .ephemeral
        self.instanceUUID = instanceUUID
        self.accessToken = accessToken
    }

    internal func authorization(for request: URLRequest) async throws -> SessionAuthorization? {
        return .bearer(accessToken)
    }
}

internal actor RequestRecorder {
    internal struct Value: Sendable {
        internal let request: URLRequest
        internal let requirement: ATRequestAuthorizationRequirement
    }

    internal private(set) var values: [Value] = []

    internal func record(
        _ request: URLRequest,
        requirement: ATRequestAuthorizationRequirement
    ) {
        values.append(Value(request: request, requirement: requirement))
    }
}

internal func successfulExecutor(
    recordingTo recorder: RequestRecorder
) -> ClosureATRequestExecutor {
    return ClosureATRequestExecutor { request, requirement in
        await recorder.record(request, requirement: requirement)
        let response = try #require(HTTPURLResponse(
            url: request.url ?? URL(fileURLWithPath: "/"),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
        return (Data("{}".utf8), response)
    }
}
