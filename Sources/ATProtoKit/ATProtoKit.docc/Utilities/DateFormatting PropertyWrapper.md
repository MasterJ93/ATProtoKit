# Custom Date Encoding and Decoding

Convert dates to and from the ISO8601 format.

@Metadata {
    @PageColor(blue)
}

## Overview

AT Protocol requires that dates must be formatted in the ISO8601 format. ATProtoKit gives you the tools to convert from `Date` to ISO8601 formatted dates and vice versa with custom `Decodable` and `Encodable` methods. All methods use ``CustomDateFormatter`` to do the decoding and encoding.

> Note: The methods should be used over the ``ATProtoKit/DateFormatting`` and ``ATProtoKit/DateFormattingOptional`` property wrappers, which are now deprecated.

## Usage

The easiest way to do this is by using the `@ATLexiconModel` macro:

```swift
@ATLexiconModel
public struct UserProfile: ATRecordProtocol {
    public static private(set) var type = "com.example.actor.profile"
    public let userID: Int
    public let username: String
    public var bio: String?
    public var avatarURL: URL?
    public var followerCount: Int?
    public var followingCount: Int?
    public let createdAt: Date
}
```

This will automatically create the custom initializer, as well as the custom decoding initializer and encoding method, in order to insert the appropriate methods.

## Manual Entry

If you rather write the custom initializers and methods manually, you can do so as well. When creating the custom initializers and methods, you'll want to replace the following methods with the custom ones:
- Replace `decode(_:forKey:)` with ``decodeDate(from:forKey:)``.
- Replace `decodeIfPresent(_:forKey:)` with ``decodeDateIfPresent(from:forKey:)``.
- Replace `encode(_:forKey:)` with ``encodeDate(_:with:forKey:)``.
- Replace `encodeIfPresent(_:forKey:)` with ``encodeDateIfPresent(_:with:forKey:)``.

```swift
public struct UserProfile: ATRecordProtocol {
    public static private(set) var type = "com.example.actor.profile"
    public let userID: Int
    public let username: String
    public var bio: String?
    public var avatarURL: URL?
    public var followerCount: Int?
    public var followingCount: Int?
    public let createdAt: Date

    public init(userID: Int, username: String, bio: String? = nil, avatarURL: URL? = nil,
                followerCount: Int? = nil, followingCount: Int? = nil, createdAt: Date) {
        self.userID = userID
        self.username = username
        self.bio = bio
        self.avatarURL = avatarURL
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.createdAt = createdAt
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.userID = try container.decode(Int.self, forKey: .userID)
        self.username = try container.decode(String.self, forKey: .username)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.avatarURL = try container.decodeIfPresent(URL.self, forKey: .avatarURL)
        self.followerCount = try container.decodeIfPresent(Int.self, forKey: .followerCount)
        self.followingCount = try container.decodeIfPresent(Int.self, forKey: .followingCount)
        // Replace `container.decode(Date.self, forKey: .createAt)`.
        self.createdAt = try decodeDate(from: container, forKey: .createdAt)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.userID, forKey: .userID)
        try container.encode(self.username, forKey: .username)
        try container.encodeIfPresent(self.bio, forKey: .bio)
        try container.encodeIfPresent(self.avatarURL, forKey: .avatarURL)
        try container.encodeIfPresent(self.followerCount, forKey: .followerCount)
        try container.encodeIfPresent(self.followingCount, forKey: .followingCount)
        // Replace `container.encode(self.createdAt, forKey: .createdAt)`.
        try encodeDate(self.createdAt, with: &container, forKey: .createdAt)
    }

    enum CodingKeys: CodingKey {
        case userID
        case username
        case bio
        case avatarURL
        case followerCount
        case followingCount
        case createdAt
    }
}
```


## Topics
### CustomDateFormatter
- ``CustomDateFormatter``

### Decodable Methods
- ``decodeDate(from:forKey:)``
- ``decodeDateIfPresent(from:forKey:)``

### Encodable Methods
- ``encodeDate(_:with:forKey:)``
- ``encodeDateIfPresent(_:with:forKey:)``

### Deprecated Property Wrappers
- ``ATProtoKit/DateFormatting``
- ``ATProtoKit/DateFormattingOptional``
