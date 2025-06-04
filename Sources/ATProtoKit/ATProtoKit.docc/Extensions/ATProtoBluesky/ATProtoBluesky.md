# ``ATProtoKit/ATProtoBluesky``

## Topics

### Instance Properties

- ``linkBuilder``
- ``sessionConfiguration``

### Initializers

- ``init(atProtoKitInstance:linkbuilder:)``

### Creating Posts

- ``createPostRecord(text:inlineFacets:locales:replyTo:embed:labels:tags:creationDate:recordKey:shouldValidate:swapCommit:)``
- <doc:ATLinkBuilderProtocol>
- ``ATLinkBuilder``

### Postgates and Threadgates

- ``createPostgateRecord(postURI:detachedEmbeddingURIs:embeddingRules:shouldValidate:swapCommit:)``
- ``updatePostgateRecord(postURI:detachedEmbeddingURIs:embeddingRules:)``

- ``createThreadgateRecord(postURI:replyControls:hiddenReplyURIs:shouldValidate:swapCommit:)``
- ``updateThreadgateRecord(postURI:replyControls:hiddenReplyURIs:)``

### Likes

- ``createLikeRecord(_:createdAt:via:recordKey:shouldValidate:swapCommit:)``

### Reposts

- ``createRepostRecord(_:createdAt:via:shouldValidate:)``

### Follows and Blocks

- ``createFollowRecord(actorDID:createdAt:recordKey:shouldValidate:swapCommit:)``

- ``createBlockRecord(ofType:createdAt:recordKey:shouldValidate:swapCommit:)``

### Profiles

- ``createProfileRecord(with:description:avatarImage:bannerImage:labels:joinedViaStarterPack:pinnedPost:recordKey:shouldValidate:swapCommit:)``
- ``updateProfileRecord(profileURI:replace:)``

### Lists

- ``createListRecord(named:ofType:description:listAvatarImage:labels:creationDate:recordKey:shouldValidate:swapCommit:)``
- ``updateListRecord(listURI:replace:)``

- ``createListItemRecord(for:subjectDID:recordKey:shouldValidate:swapCommit:)``

### Status

- ``createStatusRecord(_:embed:durationMinutes:shouldValidate:)``

<!--### Starter Packs-->

<!--### Feed Generators-->

<!--### Labeler Services-->

### Thread Navigation

- ``getOriginalPost(from:)``

### Viewing Feeds

- ``viewTrendingFeed(_:limit:)``

### Record Deletion

- ``deleteRecord(_:)``

### Errors

- ``ATBlueskyError``
- ``ATProtoBlueskyError``
- ``ATLinkBuilderError``

### Utilities and Types

- ``addQuotePostToEmbed(_:)``
- ``buildExternalEmbed(from:title:description:thumbnailImageURL:session:)``
- ``buildVideo(_:with:altText:aspectRatio:pollingFrequency:pdsURL:accessToken:)``
- ``grabURL(from:linkbuilder:)``
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
