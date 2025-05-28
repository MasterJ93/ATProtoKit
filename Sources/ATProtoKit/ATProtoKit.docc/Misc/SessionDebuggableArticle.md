# Inspecting JSON with SessionDebuggable
Learn how to inspect JSON objects in your requests and responses.

## Overview

When building apps that communicate over HTTP, bugs often arise when the JSON sent or received doesn’t match what your code expects. Debugging these issues is much easier when you can inspect the _actual_ request and response payloads, headers, and endpoints.

For this reason, ATProtoKit introduces a flexible debugging protocol: ``SessionDebuggable``.

---

`SessionDebuggable` is a simple protocol that lets you inspect every outgoing request and incoming response—including JSON payloads, headers, and URLs. By plugging in your own implementation, you control _how_ and _where_ this information is displayed or captured.

Here’s the protocol definition:

```swift
public protocol SessionDebuggable: Sendable {
    // Called before a request is sent.
    func logRequest(_ request: URLRequest, body: Data?)

    // Called after a response is received.
    func logResponse(_ response: URLResponse?, data: Data?, error: Error?)
}
```

- ``SessionDebuggable/logRequest(_:body:)`` displays information about the outgoing request.
- ``SessionDebuggable/logResponse(_:data:error:)`` displays details about the received response, including errors (if any).

---

## Using the Built-in ConsoleDebugger

ATProtoKit provides a default implementation called ``ConsoleDebugger``. It prints request and response details to the console, including:

- Request URL and method;
- Headers;
- JSON body (if present); and
- Response status code, headers, and body.

To enable it, add this line before making network requests:

```swift
await APIClientService.shared.setLogger(ConsoleDebugger())
```

- Tip: If you do nothing, debugging is disabled by default (`nil`), so there’s no runtime overhead in production.

- Note: All debugging via `SessionDebuggable` and `ConsoleDebugger` runs only in debug mode.

---

## Implementing Your Own Debugger

You aren’t limited to printing to the console. You can log to a file, upload logs for analysis, or even display them in your app’s debug UI. Just conform to the `SessionDebuggable` protocol:

```swift
public struct FileDebugger: SessionDebuggable {
    public func logRequest(_ request: URLRequest, body: Data?) {
        // Write request details to a file...
    }

    public func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        // Write response details to a file...
    }
}
```

Then, enable your custom debugger:

```swift
await APIClientService.shared.setLogger(FileDebugger())
```
