# Retrieving Records with getRecord()

Get records easily without explicit pattern matching in only one line.

## Overview

Records are one of the most important aspects of the AT Protocol, as it's what allows you to create posts, likes, reposts, and more. As a result, you'll be referencing them often. All records in ATProtoKit conform to ``ATRecordProtocol``, and any lexicon models that have records as the value will have ``UnknownType`` as the value type. Typically speaking, when referencing a record, you would use `if case let` or `guard case let`, and then grab the results from there. However, doing this requires using multiple lines and handling different scopes.

To solve this problem, ``UnknownType`` has a public method method, named ``UnknownType/getRecord(ofType:)``. This will allow you to reference a record in one line.

## Referencing a Record

You can call the method on a property that has ``UnknownType`` as the value type:

```swift
do {
    let postArray = atProto.searchPosts(with: "atprotokit")
    let post = postArray.posts[0].record.getRecord(ofType: AppBskyLexicon.Feed.PostRecord.self).text
} catch {
    // error...
}
```

There's one required parameter used tell the method which `struct` to decode the JSON response to. Make sure you add `.self` at the end of the name of the `struct`.
