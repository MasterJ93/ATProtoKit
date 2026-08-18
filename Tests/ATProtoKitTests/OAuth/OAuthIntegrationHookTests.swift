import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Testing
@testable import ATProtoKit

@Suite("OAuth integration hooks")
struct OAuthIntegrationHookTests {
    @Test("Executor receives structured requirements and final bodies")
    func executorReceivesStructuredRequirementsAndFinalBodies() async throws {
        let recorder = RequestRecorder()
        let executor = ClosureATRequestExecutor { request, requirement in
            await recorder.record(request, requirement: requirement)
            let response = try #require(HTTPURLResponse(
                url: request.url ?? URL(fileURLWithPath: "/"),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
            return (Data("{}".utf8), response)
        }
        let service = APIClientService(with: APIClientConfiguration(responseProvider: executor))
        let protectedURL = try #require(URL(string: "https://pds.example/xrpc/com.atproto.repo.createRecord"))
        let publicURL = try #require(URL(string: "https://public.example/xrpc/app.bsky.feed.getPostThread"))
        let protectedRequest = service.createRequest(
            forRequest: protectedURL,
            andMethod: .post,
            requiresAuthorization: true
        )
        let publicRequest = service.createRequest(forRequest: publicURL, andMethod: .get)

        _ = try await service.sendRequest(protectedRequest, withEncodingBody: TestBody(value: "final"))
        _ = try await service.sendRequest(publicRequest)

        let values = await recorder.values
        #expect(values.map(\.requirement) == [.session, .none])
        #expect(values[0].request.httpBody == Data(#"{"value":"final"}"#.utf8))
        #expect(values[0].request.value(forHTTPHeaderField: "X-ATProtoKit-Requires-Authorization") == nil)
    }

    @Test("Refresh uses the refresh hook and replaces visible context")
    func refreshUsesRefreshHook() async throws {
        let instanceUUID = UUID()
        let refreshedURL = try #require(URL(string: "https://refreshed.example"))
        let configuration = ATOAuthSessionConfiguration(
            pdsURL: "https://pds.example",
            instanceUUID: instanceUUID,
            requestExecutor: successfulExecutor(recordingTo: RequestRecorder()),
            contextProvider: { nil },
            refreshHandler: {
                SessionAuthorizationContext(
                    sessionDID: "did:plc:refreshed",
                    serviceEndpoint: refreshedURL,
                    grantedScopes: ["atproto", "repo:app.bsky.feed.post"]
                )
            }
        )

        try await configuration.synchronizeSession()
        let session = try #require(await UserSessionRegistry.shared.getSession(for: instanceUUID))
        #expect(session.sessionDID == "did:plc:refreshed")
        #expect(session.serviceEndpoint == refreshedURL)
    }

    @Test("Synchronization can reload context without an explicit refresh hook")
    func synchronizationCanReloadContextWithoutRefreshHook() async throws {
        let endpoint = try #require(URL(string: "https://pds.example"))
        let configuration = ATOAuthSessionConfiguration(
            pdsURL: "https://pds.example",
            requestExecutor: successfulExecutor(recordingTo: RequestRecorder()),
            contextProvider: {
                SessionAuthorizationContext(
                    sessionDID: "did:plc:synchronized",
                    serviceEndpoint: endpoint,
                    grantedScopes: ["atproto"]
                )
            }
        )

        try await configuration.synchronizeSession()

        let context = try #require(try await configuration.authorizationContext())
        #expect(context.sessionDID == "did:plc:synchronized")
    }

    @Test("Sensitive diagnostic headers are redacted case-insensitively")
    func sensitiveHeadersAreRedacted() {
        let headers = ConsoleDebugger.redactedHeaders([
            "aUtHoRiZaTiOn": "secret",
            "DPoP": "proof",
            "X-Visible": "value"
        ])
        #expect(headers["aUtHoRiZaTiOn"] == "<redacted>")
        #expect(headers["DPoP"] == "<redacted>")
        #expect(headers["X-Visible"] == "value")
    }

    @Test("Granted scopes preserve exact values")
    func grantedScopesPreserveExactValues() throws {
        let endpoint = try #require(URL(string: "https://pds.example"))
        let context = SessionAuthorizationContext(
            sessionDID: "did:plc:test",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto", "repo:app.bsky.feed.post"]
        )
        #expect(context.hasGrantedScope("repo:app.bsky.feed.post"))
        #expect(!context.hasGrantedScope("repo:*"))
    }

    @Test("OAuth configuration preserves granted scopes after registration")
    func oauthConfigurationPreservesGrantedScopes() async throws {
        let endpoint = try #require(URL(string: "https://pds.example"))
        let expectedContext = SessionAuthorizationContext(
            sessionDID: "did:plc:test",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto", "repo:app.bsky.feed.post"]
        )
        let configuration = ATOAuthSessionConfiguration(
            pdsURL: endpoint.absoluteString,
            requestExecutor: successfulExecutor(recordingTo: RequestRecorder()),
            contextProvider: { expectedContext }
        )

        try await configuration.registerSession()

        let context = try #require(try await configuration.authorizationContext())
        #expect(context == expectedContext)
    }

    @Test("Fixed-context initializer derives the PDS and registers the context")
    func fixedContextInitializerDerivesPDSAndRegistersContext() async throws {
        let instanceUUID = UUID()
        let endpoint = try #require(URL(string: "https://fixed-context.example"))
        let expectedContext = SessionAuthorizationContext(
            sessionDID: "did:plc:fixedcontext",
            handle: "fixed.example",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto"]
        )
        let configuration = ATOAuthSessionConfiguration(
            context: expectedContext,
            instanceUUID: instanceUUID,
            requestExecutor: successfulExecutor(recordingTo: RequestRecorder())
        )

        #expect(configuration.pdsURL == endpoint.absoluteString)
        #expect(try await configuration.authorizationContext() == expectedContext)

        try await configuration.registerSession()

        let session = try #require(await UserSessionRegistry.shared.getSession(for: instanceUUID))
        #expect(session.sessionDID == expectedContext.sessionDID)
        #expect(session.handle == expectedContext.handle)
        #expect(session.serviceEndpoint == endpoint)
        await UserSessionRegistry.shared.removeSession(for: instanceUUID)
    }

    @Test("OAuth client factory registers context and uses its PDS")
    func oauthClientFactoryRegistersContextAndUsesItsPDS() async throws {
        let instanceUUID = UUID()
        let endpoint = try #require(URL(string: "https://factory-pds.example"))
        let context = SessionAuthorizationContext(
            sessionDID: "did:plc:factory",
            handle: "factory.example",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto"]
        )
        let configuration = ATOAuthSessionConfiguration(
            context: context,
            instanceUUID: instanceUUID,
            requestExecutor: successfulExecutor(recordingTo: RequestRecorder())
        )

        let client = try await ATProtoKit.createOAuthSession(
            sessionConfiguration: configuration,
            canUseBlueskyRecords: false
        )

        #expect(client.pdsURL == endpoint.absoluteString)
        #expect(client.sessionConfiguration?.instanceUUID == instanceUUID)
        let session = try #require(await UserSessionRegistry.shared.getSession(for: instanceUUID))
        #expect(session.sessionDID == context.sessionDID)
        #expect(session.serviceEndpoint == endpoint)
        await UserSessionRegistry.shared.removeSession(for: instanceUUID)
    }

    @Test("OAuth client factory rejects an invalid fixed context")
    func oauthClientFactoryRejectsInvalidFixedContext() async throws {
        let instanceUUID = UUID()
        let endpoint = try #require(URL(string: "https://factory-pds.example"))
        let context = SessionAuthorizationContext(
            sessionDID: "not-a-did",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto"]
        )
        let configuration = ATOAuthSessionConfiguration(
            context: context,
            instanceUUID: instanceUUID,
            requestExecutor: successfulExecutor(recordingTo: RequestRecorder())
        )

        await #expect(throws: ATOAuthSessionConfigurationError.invalidSessionDID(did: "not-a-did")) {
            _ = try await ATProtoKit.createOAuthSession(
                sessionConfiguration: configuration,
                canUseBlueskyRecords: false
            )
        }
        #expect(await UserSessionRegistry.shared.getSession(for: instanceUUID) == nil)
    }

    @Test("OAuth registration rejects a missing profile scope")
    func oauthRegistrationRejectsMissingProfileScope() async throws {
        let endpoint = try #require(URL(string: "https://pds.example"))
        let context = SessionAuthorizationContext(
            sessionDID: "did:plc:test",
            serviceEndpoint: endpoint,
            grantedScopes: ["repo:app.bsky.feed.post"]
        )
        let configuration = ATOAuthSessionConfiguration(
            pdsURL: endpoint.absoluteString,
            requestExecutor: successfulExecutor(recordingTo: RequestRecorder()),
            contextProvider: { context }
        )

        await #expect(throws: ATOAuthSessionConfigurationError.missingATProtoScope) {
            try await configuration.registerSession()
        }
    }

    @Test("Concrete configurations expose focused session capabilities")
    func concreteConfigurationsExposeFocusedCapabilities() {
        requireAppPasswordCapabilities(ATProtocolConfiguration.self)
        requireOAuthCapabilities(ATOAuthSessionConfiguration.self)
    }

    @Test("OAuth registration rejects invalid identity context")
    func oauthRegistrationRejectsInvalidIdentityContext() async throws {
        let endpoint = try #require(URL(string: "http://pds.example?unsafe=true"))
        let context = SessionAuthorizationContext(
            sessionDID: "not-a-did",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto"]
        )

        #expect(throws: ATOAuthSessionConfigurationError.invalidSessionDID(did: "not-a-did")) {
            try context.validate()
        }
    }

    @Test("OAuth context rejects an insecure PDS endpoint")
    func oauthContextRejectsInsecurePDSEndpoint() async throws {
        let endpoint = try #require(URL(string: "http://pds.example?unsafe=true"))
        let context = SessionAuthorizationContext(
            sessionDID: "did:plc:test",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto"]
        )

        #expect(throws: ATOAuthSessionConfigurationError.invalidServiceEndpoint(endpoint: endpoint)) {
            try context.validate()
        }
    }

    @Test("OAuth context rejects a PDS endpoint with a path prefix")
    func oauthContextRejectsPDSEndpointWithPathPrefix() throws {
        let endpoint = try #require(URL(string: "https://pds.example/account/tenant"))
        let context = SessionAuthorizationContext(
            sessionDID: "did:plc:test",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto"]
        )

        #expect(throws: ATOAuthSessionConfigurationError.invalidServiceEndpoint(endpoint: endpoint)) {
            try context.validate()
        }
    }

    @Test("Blob uploads use the registered OAuth session PDS")
    func blobUploadsUseRegisteredOAuthSessionPDS() async throws {
        let recorder = RequestRecorder()
        let endpoint = try #require(URL(string: "https://self-hosted.example"))
        let executor = ClosureATRequestExecutor { request, requirement in
            await recorder.record(request, requirement: requirement)
            let response = try #require(HTTPURLResponse(
                url: request.url ?? URL(fileURLWithPath: "/"),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
            let responseData = Data(
                #"{"blob":{"$type":"blob","ref":{"$link":"bafkreitest"},"mimeType":"image/png","size":5}}"#.utf8
            )
            return (responseData, response)
        }
        let configuration = ATOAuthSessionConfiguration(
            pdsURL: endpoint.absoluteString,
            requestExecutor: executor,
            contextProvider: {
                SessionAuthorizationContext(
                    sessionDID: "did:plc:test",
                    serviceEndpoint: endpoint,
                    grantedScopes: ["atproto", "blob:image/*"]
                )
            }
        )
        try await configuration.registerSession()
        let kit = await ATProtoKit(sessionConfiguration: configuration, canUseBlueskyRecords: false)

        let blob = try await kit.uploadBlob(Data("image".utf8), contentType: "image/png")

        let value = try #require(await recorder.values.first)
        #expect(blob.reference.link == "bafkreitest")
        #expect(blob.mimeType == "image/png")
        #expect(blob.size == 5)
        #expect(value.requirement == .session)
        #expect(value.request.url?.absoluteString == "https://self-hosted.example/xrpc/com.atproto.repo.uploadBlob")
        #expect(value.request.value(forHTTPHeaderField: "Content-Type") == "image/png")
        #expect(value.request.httpBody == Data("image".utf8))
    }

    @Test("Blob uploads use the shared header-authenticated request path")
    func blobUploadsUseSharedHeaderAuthenticatedRequestPath() async throws {
        let recorder = RequestRecorder()
        let endpoint = try #require(URL(string: "https://app-password-pds.example"))
        let configuration = HeaderSessionConfiguration(
            pdsURL: endpoint.absoluteString,
            instanceUUID: UUID()
        )
        let executor = ClosureATRequestExecutor { request, requirement in
            await recorder.record(request, requirement: requirement)
            throw TestExecutorError.requestRecorded
        }
        let session = UserSession(
            handle: "test.example",
            sessionDID: "did:plc:test",
            isEmailAuthenticationFactorEnabled: nil,
            isActive: true,
            status: nil,
            serviceEndpoint: endpoint
        )
        await UserSessionRegistry.shared.register(configuration.instanceUUID, session: session)
        let kit = await ATProtoKit(
            sessionConfiguration: configuration,
            apiClientConfiguration: APIClientConfiguration(responseProvider: executor),
            canUseBlueskyRecords: false
        )

        await #expect(throws: TestExecutorError.requestRecorded) {
            _ = try await kit.uploadBlob(Data("blob".utf8), contentType: "application/octet-stream")
        }

        let value = try #require(await recorder.values.first)
        #expect(value.requirement == .session)
        #expect(value.request.url?.absoluteString == "https://app-password-pds.example/xrpc/com.atproto.repo.uploadBlob")
        #expect(value.request.value(forHTTPHeaderField: "Authorization") == "Bearer app-password-access-token")
        #expect(value.request.value(forHTTPHeaderField: "Content-Type") == "application/octet-stream")
        #expect(value.request.httpBody == Data("blob".utf8))
        await UserSessionRegistry.shared.removeSession(for: configuration.instanceUUID)
    }

    @Test("Get session uses the OAuth executor")
    private func getSessionUsesOAuthExecutor() async throws {
        let recorder = RequestRecorder()
        let endpoint = try #require(URL(string: "https://oauth-pds.example"))
        let executor = ClosureATRequestExecutor { request, requirement in
            await recorder.record(request, requirement: requirement)
            let response = try #require(HTTPURLResponse(
                url: request.url ?? URL(fileURLWithPath: "/"),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
            return (sessionResponseData(), response)
        }
        let context = SessionAuthorizationContext(
            sessionDID: "did:plc:oauth",
            handle: "oauth.example",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto"]
        )
        let configuration = ATOAuthSessionConfiguration(
            context: context,
            requestExecutor: executor
        )
        let client = try await ATProtoKit.createOAuthSession(
            sessionConfiguration: configuration,
            canUseBlueskyRecords: false
        )

        let session = try await client.getSession()

        let value = try #require(await recorder.values.first)
        #expect(session.handle == "session.example")
        #expect(value.requirement == .session)
        #expect(value.request.url?.absoluteString == "https://oauth-pds.example/xrpc/com.atproto.server.getSession")
        await UserSessionRegistry.shared.removeSession(for: configuration.instanceUUID)
    }

    @Test("Get session uses App Password-style header authorization")
    private func getSessionUsesHeaderAuthorization() async throws {
        let recorder = RequestRecorder()
        let endpoint = try #require(URL(string: "https://app-password-pds.example"))
        let configuration = HeaderSessionConfiguration(
            pdsURL: endpoint.absoluteString,
            instanceUUID: UUID()
        )
        let executor = ClosureATRequestExecutor { request, requirement in
            await recorder.record(request, requirement: requirement)
            let response = try #require(HTTPURLResponse(
                url: request.url ?? URL(fileURLWithPath: "/"),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
            return (sessionResponseData(), response)
        }
        let client = await ATProtoKit(
            sessionConfiguration: configuration,
            apiClientConfiguration: APIClientConfiguration(responseProvider: executor),
            pdsURL: endpoint.absoluteString,
            canUseBlueskyRecords: false
        )

        let session = try await client.getSession()

        let value = try #require(await recorder.values.first)
        #expect(session.did == "did:plc:session")
        #expect(value.requirement == .session)
        #expect(value.request.url?.absoluteString == "https://app-password-pds.example/xrpc/com.atproto.server.getSession")
        #expect(value.request.value(forHTTPHeaderField: "Authorization") == "Bearer app-password-access-token")
    }

    @Test("Protected methods preserve their lexicon NSIDs")
    func protectedMethodsPreserveLexiconNSIDs() async throws {
        let recorder = RequestRecorder()
        let endpoint = try #require(URL(string: "https://pds.example"))
        let executor = ClosureATRequestExecutor { request, requirement in
            await recorder.record(request, requirement: requirement)
            throw TestExecutorError.requestRecorded
        }
        let configuration = ATOAuthSessionConfiguration(
            pdsURL: endpoint.absoluteString,
            requestExecutor: executor,
            contextProvider: {
                SessionAuthorizationContext(
                    sessionDID: "did:plc:test",
                    serviceEndpoint: endpoint,
                    grantedScopes: ["atproto"]
                )
            }
        )
        try await configuration.registerSession()
        let kit = await ATProtoKit(sessionConfiguration: configuration, canUseBlueskyRecords: false)

        await #expect(throws: TestExecutorError.requestRecorded) {
            try await kit.requestPLCOperationSignature()
        }
        await #expect(throws: TestExecutorError.requestRecorded) {
            _ = try await kit.checkHandleAvailability(handle: "available.example")
        }
        await #expect(throws: TestExecutorError.requestRecorded) {
            try await kit.revokeAccountCredentials(account: "did:plc:test")
        }

        let values = await recorder.values
        #expect(values.map(\.requirement) == [.session, .session, .session])
        #expect(values.compactMap(\.request.url?.path) == [
            "/xrpc/com.atproto.identity.requestPlcOperationSignature",
            "/xrpc/com.atproto.temp.checkHandleAvailability",
            "/xrpc/com.atproto.temp.revokeAccountCredentials"
        ])
    }

    @Test("Permission checks report exact missing scopes")
    func permissionChecksReportExactMissingScopes() async throws {
        let endpoint = try #require(URL(string: "https://pds.example"))
        let context = SessionAuthorizationContext(
            sessionDID: "did:plc:test",
            serviceEndpoint: endpoint,
            grantedScopes: ["atproto", "repo:app.bsky.feed.post"]
        )

        #expect(context.missingGrantedScopes(from: [
            "repo:app.bsky.feed.post",
            "blob:image/*"
        ]) == ["blob:image/*"])
        #expect(throws: ATOAuthSessionConfigurationError.insufficientScopes(scopes: ["blob:image/*"])) {
            try context.requireGrantedScopes(["repo:app.bsky.feed.post", "blob:image/*"])
        }
    }

    @Test("OAuth-owned executor cannot be displaced by a custom transport")
    func oauthOwnedExecutorCannotBeDisplaced() async throws {
        let oauthRecorder = RequestRecorder()
        let replacementRecorder = RequestRecorder()
        let oauthExecutor = ClosureATRequestExecutor { request, requirement in
            await oauthRecorder.record(request, requirement: requirement)
            let response = try #require(HTTPURLResponse(
                url: request.url ?? URL(fileURLWithPath: "/"),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
            return (Data("{}".utf8), response)
        }
        let replacementExecutor = ClosureATRequestExecutor { request, requirement in
            await replacementRecorder.record(request, requirement: requirement)
            let response = try #require(HTTPURLResponse(
                url: request.url ?? URL(fileURLWithPath: "/"),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
            return (Data("{}".utf8), response)
        }
        let configuration = ATOAuthSessionConfiguration(
            pdsURL: "https://pds.example",
            requestExecutor: oauthExecutor,
            contextProvider: { nil }
        )
        let kit = await ATProtoKit(
            sessionConfiguration: configuration,
            apiClientConfiguration: APIClientConfiguration(responseProvider: replacementExecutor),
            canUseBlueskyRecords: false
        )
        let url = try #require(URL(string: "https://pds.example/xrpc/test"))
        let request = kit.apiClientService.createRequest(
            forRequest: url,
            andMethod: .get,
            requiresAuthorization: true
        )

        _ = try await kit.apiClientService.sendRequest(request)

        #expect(await oauthRecorder.values.count == 1)
        #expect(await replacementRecorder.values.isEmpty)
    }

    @Test("Admin client also preserves OAuth executor ownership")
    func adminClientPreservesOAuthExecutorOwnership() async throws {
        let oauthRecorder = RequestRecorder()
        let replacementRecorder = RequestRecorder()
        let oauthExecutor = successfulExecutor(recordingTo: oauthRecorder)
        let replacementExecutor = successfulExecutor(recordingTo: replacementRecorder)
        let configuration = ATOAuthSessionConfiguration(
            pdsURL: "https://pds.example",
            requestExecutor: oauthExecutor,
            contextProvider: { nil }
        )
        let admin = await ATProtoAdmin(
            sessionConfiguration: configuration,
            apiClientConfiguration: APIClientConfiguration(responseProvider: replacementExecutor)
        )
        let url = try #require(URL(string: "https://pds.example/xrpc/test"))
        let request = admin.apiClientService.createRequest(
            forRequest: url,
            andMethod: .get,
            requiresAuthorization: true
        )

        _ = try await admin.apiClientService.sendRequest(request)

        #expect(await oauthRecorder.values.count == 1)
        #expect(await replacementRecorder.values.isEmpty)
    }

}

private func requireAppPasswordCapabilities<Configuration>(_: Configuration.Type)
where Configuration: SessionConfiguration,
      Configuration: AppPasswordSessionManaging,
      Configuration: AppPasswordCredentialStoring,
      Configuration: AppPasswordAuthenticating,
      Configuration: ATAccountCreating,
      Configuration: UserSessionRegistryManaging {
}

private func requireOAuthCapabilities<Configuration>(_: Configuration.Type)
where Configuration: SessionConfiguration,
      Configuration: OAuthSessionSynchronizing,
      Configuration: UserSessionRegistryManaging {
}

private struct TestBody: Encodable, Sendable {
    let value: String
}

private enum TestExecutorError: Error {
    case requestRecorded
}

private func sessionResponseData() -> Data {
    return Data(#"{"handle":"session.example","did":"did:plc:session","active":true}"#.utf8)
}

private final class HeaderSessionConfiguration: SessionConfiguration {
    private let accessToken: String

    let pdsURL: String
    let configuration: URLSessionConfiguration
    let instanceUUID: UUID

    init(
        pdsURL: String,
        instanceUUID: UUID,
        accessToken: String = "app-password-access-token"
    ) {
        self.pdsURL = pdsURL
        self.configuration = .ephemeral
        self.instanceUUID = instanceUUID
        self.accessToken = accessToken
    }

    func authorization(for request: URLRequest) async throws -> SessionAuthorization? {
        return .bearer(accessToken)
    }
}

private actor RequestRecorder {
    struct Value: Sendable {
        let request: URLRequest
        let requirement: ATRequestAuthorizationRequirement
    }

    private(set) var values: [Value] = []

    func record(_ request: URLRequest, requirement: ATRequestAuthorizationRequirement) {
        values.append(Value(request: request, requirement: requirement))
    }
}

private func successfulExecutor(recordingTo recorder: RequestRecorder) -> ClosureATRequestExecutor {
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
