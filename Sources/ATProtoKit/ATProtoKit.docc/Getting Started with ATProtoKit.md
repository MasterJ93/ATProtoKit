# Getting Started with ATProtoKit

Sign in with a Bluesky account, send a post, and view the account's posts.

@Metadata {
    @PageImage(
        purpose: icon, 
        source: "bluesky_logo", 
        alt: "A technology icon representing the ATProtoKit framework.")
    @PageColor(blue)
}

## Overview

ATProtoKit is designed to make it easy for you to interact with the AT Protocol and other services built on of the technology, such as Bluesky. 

### Creating a session

In order to log in, you need to create a session. To get started, create a new ``ATProtocolConfiguration`` instance:

```swift
let config = ATProtocolConfiguration(handle: "lucy.bsky.social", appPassword: "g8DBhaj-948uBho-Zh6c8Wl")
```
 
> Important: Do not use the password you typically use for signing into Bluesky: only use a specific App Password that's in use for this instance of ATProtoKit only. To generate an App Password, go to the Bluesky website, then go to Settings > Advanced > App Passwords and follow the instructions.

Then, you can create a session with the ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)`` method:

```swift
Task {
    let session = try await config.authenticate()
}
```

You can use a `do-catch` block to get the ``UserSession`` instance (if the session was successfully created) or handle the error (if an error occured):

```swift
let config = ATProtocolConfiguration(handle: "lucy.bsky.social", appPassword: "hunter2")

Task {
    do {
        let session = try await config.authenticate()

        // Handle the success.
    } catch {
        // Handle the error.
    }
}
```

> Note: If you've enabled Two-Factor Authentication (via email), you may see an `AuthFactorTokenRequired` error. In that case, check your inbox for a code, then call ``ATProtocolConfiguration/authenticate(authenticationFactorToken:)`` again, but put in the code for the `authenticationFactorToken` parameter.

``UserSession`` will contain, among other things, the access and refresh tokens. ATProtoKit abstracts this away for you so you don't need to add it every time you use a method that requires an active session.

You can then create an ``ATProtoKit/ATProtoKit`` instance, where you can insert the ``UserSession`` object in the `result` parameter:

```swift
let atProto = ATProtoKit(session: result)
```

### Creating a post
To create a post, use the ``ATProtoKit/ATProtoKit/createPostRecord(text:locales:replyTo:embed:labels:tags:creationDate:recordKey:shouldValidate:swapCommit:)`` method. While this method is extremely extensive, we're only going to focus on the `text` parameter.

```swift
let postResult = await atProto.createPostRecord(text: "Hello Bluesky!")
```

You should see the post in your Bluesky account once you run this code. When the method successfully completes, you'll receive a ``ComAtprotoLexicon/Repository/StrongReference`` object that contains the URI of the record (``ComAtprotoLexicon/Repository/StrongReference/recordURI``) and the content identifier hash of the record (``ComAtprotoLexicon/Repository/StrongReference/cidHash``).
