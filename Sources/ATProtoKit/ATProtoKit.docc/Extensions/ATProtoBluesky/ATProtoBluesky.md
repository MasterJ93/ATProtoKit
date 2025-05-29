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

### Postgates and Threadgates

- ``createPostgateRecord(postURI:detachedEmbeddingURIs:embeddingRules:shouldValidate:swapCommit:)``

- ``createThreadgateRecord(postURI:replyControls:hiddenReplyURIs:shouldValidate:swapCommit:)``

### Managing Liking and Unliking

- ``createLikeRecord(_:createdAt:recordKey:shouldValidate:swapCommit:)``

### Managing Reposts

- ``createRepostRecord(_:createdAt:shouldValidate:)``

### Managing Follows and Blocks

- ``createFollowRecord(actorDID:createdAt:recordKey:shouldValidate:swapCommit:)``

- ``createBlockRecord(ofType:createdAt:recordKey:shouldValidate:swapCommit:)``

### Managing Profiles

- ``createProfileRecord(with:description:avatarImage:bannerImage:labels:joinedViaStarterPack:pinnedPost:recordKey:shouldValidate:swapCommit:)``
- ``updateProfileRecord(profileURI:replace:)``

### Managing Lists

- ``createListRecord(named:ofType:description:listAvatarImage:labels:creationDate:recordKey:shouldValidate:swapCommit:)``
- ``updateListRecord(listURI:replace:)``

- ``createListItemRecord(for:subjectDID:recordKey:shouldValidate:swapCommit:)``

<!--### Managing Starter Packs-->

<!--### Managing Feed Generators-->

<!--### Managing Labeler Services-->

### Deleting Bluesky Records

- ``deleteRecord(_:)``

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
