# Custom Date Encoding and Decoding

Convert dates to and from the ISO8601 format.

@Metadata {
    @PageColor(blue)
}

## Overview

The AT Protocol requires that dates must be formatted in the ISO8601 format. ATProtoKit gives you the tools to convert from `Date` to ISO8601 formatted dates and vice versa with custom `Decodable` and `Encodable` methods. All methods use ``CustomDateFormatter`` to do the decoding and encoding.

## Usage

If you rather write the custom initializers and methods manually, you can do so as well. When creating the custom initializers and methods, you'll want to replace the following methods with the custom ones:
Replace|With...
---:|:---
`decode(_:forKey:)`|``Swift/KeyedDecodingContainer/decodeDate(forKey:)``
`decodeIfPresent(_:forKey:)`|``Swift/KeyedDecodingContainer/decodeDateIfPresent(forKey:)``
`encode(_:forKey:)`|``Swift/KeyedEncodingContainer/encodeDate(_:forKey:)``
`encodeIfPresent(_:forKey:)`|``Swift/KeyedEncodingContainer/encodeDateIfPresent(_:forKey:)``

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
        self.createdAt = try container.decodeDate(forKey: .createdAt)
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
        try container.encodeDate(self.createdAt, forKey: .createdAt)
    }

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username
        case bio
        case avatarURL = "avatar_url"
        case followerCount = "follower_count"
        case followingCount = "following_count"
        case createdAt = "created_at"
    }
}
```


## Topics
### CustomDateFormatter
- ``CustomDateFormatter``

### Decodable Methods
- ``Swift/KeyedDecodingContainer/decodeDate(forKey:)``
- ``Swift/KeyedDecodingContainer/decodeDateIfPresent(forKey:)``

### Encodable Methods
- ``Swift/KeyedEncodingContainer/encodeDate(_:forKey:)``
- ``Swift/KeyedEncodingContainer/encodeDateIfPresent(_:forKey:)``
