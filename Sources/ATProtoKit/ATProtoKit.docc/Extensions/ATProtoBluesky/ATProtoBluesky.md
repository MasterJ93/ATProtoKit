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

- ``createPostgateRecord(postURI:detachedEmbeddingURIs:embeddingRules:shouldValidate:swapCommit:)``
- ``deletePostgateRecord(_:)``

- ``createThreadgateRecord(postURI:replyControls:hiddenReplyURIs:shouldValidate:swapCommit:)``
- ``deleteThreadgateRecord(_:)``

### Managing Liking and Unliking

- ``createLikeRecord(_:createdAt:recordKey:shouldValidate:swapCommit:)``
- ``deleteLikeRecord(_:)``

### Managing Reposts

- ``createRepostRecord(_:createdAt:shouldValidate:)``
- ``deleteRepostRecord(_:)``

### Managing Follows and Blocks

- ``createFollowRecord(actorDID:createdAt:recordKey:shouldValidate:swapCommit:)``
- ``deleteFollowRecord(_:)``

- ``createBlockRecord(ofType:createdAt:recordKey:shouldValidate:swapCommit:)``
- ``deleteBlockRecord(_:)``

### Managing Lists

- ``createListRecord(named:ofType:description:listAvatarImage:labels:creationDate:recordKey:shouldValidate:swapCommit:)``
- ``updateListRecord(listURI:replace:)``
- ``deleteListRecord(_:)``

- ``createListItemRecord(for:subjectDID:recordKey:shouldValidate:swapCommit:)``
- ``deleteListItemRecord(_:)``

<!--### Managing Starter Packs-->

<!--### Managing Feed Generators-->

<!--### Managing Labeler Services-->

### Errors

- ``ATBlueskyError``
- ``ATProtoBlueskyError``
- ``ATLinkBuilderError``
