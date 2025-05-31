# ``ATProtoKit/ATProtoBluesky``


## Topics

### Instance Properties

- ``linkBuilder``
- ``sessionConfiguration``

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

- ``createLikeRecord(_:createdAt:via:recordKey:shouldValidate:swapCommit:)``
- ``deleteLikeRecord(_:)``

### Managing Reposts

- ``createRepostRecord(_:createdAt:via:shouldValidate:)``
- ``deleteRepostRecord(_:)``

### Managing Follows and Blocks

- ``createFollowRecord(actorDID:createdAt:recordKey:shouldValidate:swapCommit:)``
- ``deleteFollowRecord(_:)``

- ``createBlockRecord(ofType:createdAt:recordKey:shouldValidate:swapCommit:)``
- ``deleteBlockRecord(_:)``

### Managing Profiles

- ``createProfileRecord(with:description:avatarImage:bannerImage:labels:joinedViaStarterPack:pinnedPost:recordKey:shouldValidate:swapCommit:)``
- ``updateProfileRecord(profileURI:replace:)``
- ``deleteProfileRecord(_:)``

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

### Supporting Methods and Types

- ``addQuotePostToEmbed(_:)``
- ``buildExternalEmbed(from:title:description:thumbnailImageURL:session:)``
- ``buildVideo(_:with:altText:aspectRatio:pollingFrequency:pdsURL:accessToken:)``
- ``grabURL(from:linkbuilder:)``
- ``updatePostgateRecord(postURI:detachedEmbeddingURIs:embeddingRules:)``
- ``updateThreadgateRecord(postURI:replyControls:hiddenReplyURIs:)``
- ``uploadImages(_:pdsURL:accessToken:)``
- ``pdsURL``
- ``Caption``
- ``EmbedIdentifier``
- ``PostgateEmbeddingRule``
- ``RecordIdentifier``
- ``ThreadgateAllowRule``
- ``BlockType``
- ``ListType``
- ``UpdatedListRecordField``
- ``UpdatedProfileRecordField``
