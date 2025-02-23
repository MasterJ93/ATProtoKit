# ``ATProtoKit/ATProtoBluesky``


## Topics

### Instance Properties

- ``linkBuilder``
- ``logger``
- ``session``
- ``sessionConfiguration``
- ``urlSessionConfiguration``

### Initializers

- ``init(atProtoKitInstance:linkbuilder:)``

### Managing Posts

- ``createPostRecord(text:inlineFacets:locales:replyTo:embed:labels:tags:creationDate:recordKey:shouldValidate:swapCommit:)``
- <doc:ATLinkBuilderProtocol>
- ``ATLinkBuilder``
- ``deletePostRecord(_:)``

### Postgates and Threadgates

- ``createPostgateRecord(postURI:detachedEmbeddingURIs:embeddingRules:recordKey:shouldValidate:swapCommit:)``
- ``deletePostgateRecord(_:)``



### Managing Liking and Unliking

- ``createLikeRecord(_:createdAt:recordKey:shouldValidate:swapCommit:)``
- ``deleteLikeRecord(_:)``

### Managing Reposts

- ``createRepostRecord(_:createdAt:shouldValidate:)``
- ``deleteRepostRecord(_:)``

### Managing Follows and Blocks

- ``createFollowRecord(actorDID:createdAt:recordKey:shouldValidate:swapCommit:)``
- ``deleteFollowRecord(_:)``

- ``createBlockRecord(actorDID:createdAt:recordKey:shouldValidate:swapCommit:)``
- ``deleteBlockRecord(_:)``

<!--### Managing Lists-->

<!--### Managing Starter Packs-->

<!--### Managing Feed Generators-->

<!--### Managing Labeler Services-->

### Errors

- ``ATBlueskyError``
- ``ATProtoBlueskyError``
- ``ATLinkBuilderError``
