//
//  CreatePostRecord.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to create a post record to the user account in Bluesky.
    ///
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// # Creating a Post
    /// After you authenticate into Bluesky, you can create a post by using the `text` argument:
    /// ```swift
    /// do {
    ///     let postResult = try await atProtoBluesky.createPostRecord(
    ///         text: "Just tried out the new coffee shop in town ☕️ — highly recommend the cold brew!"
    ///     )
    ///
    ///     print(postResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    /// If your post is longer than 300 characters, the method will only take the first 300
    /// characters, discarding the rest.
    ///
    /// Bluesky will automatically set the language of the post to English, but if you need to
    /// manually set it, you can use the `locales` argument:
    /// ```swift
    /// do {
    ///     let postResult = try await atProtoBluesky.createPostRecord(
    ///         text: "Première promenade d'automne 🍂. Les couleurs sont magnifiques cette année!",
    ///         locales: [Locale(identifier: "fr_FR")]
    ///     )
    ///
    ///     print(postResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// You can add up to three locales at once; only the first three items will be added as this
    /// is the limit mandated by Bluesky.
    ///
    /// `createPostRecord()` will automatically look for URLs, hashtags, and @mentions for you.
    /// However, if you would like to add inline link facets to your account, you can use the
    /// `inlineFacets` parameter:
    ///
    /// ```swift
    /// do {
    ///     let inlineFacet = (URL(string: "https://www.loc.gov/resource/pga.05046/"), 57, 72)
    ///     let postResult = try await atProtoBluesky.createPostRecord(
    ///         text: "Where's that weird photo of a cat when you need one?\n\nAh: here it is!",
    ///         inlineFacets: [inlineFacet]
    ///     )
    ///
    ///     print(postResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Note: `startPostion` and `endPostion` must be UTF-8 values.
    ///
    ///
    /// # Adding Embedded Content
    /// You can embed various kinds of content in your post, from media to external links,
    /// to other records.
    ///
    /// ## Images
    /// Use ``ATProtoTools/ImageQuery`` to add details to the image, such as
    /// alt text, then attach it to the post record.
    ///
    /// ```swift
    /// do {
    ///     let image = ATProtoTools.ImageQuery(
    ///         imageData: Data(contentsOf: "/path/to/file/cat.jpg"),
    ///         fileName: "cat.jpg",
    ///         altText: "A cat looking annoyed, wearing a hat."
    ///     )
    ///
    ///     let postResult = try await atProtoBluesky.createPostRecord(
    ///         text: "I don't think my cat likes her new hat... 🙃",
    ///         embed: .images(
    ///             images: [image]
    ///         )
    ///     )
    ///
    ///     print(postResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// Up to four images can be attached to a post. All images need to be a .jpg format.
    ///
    /// ## Videos
    /// Similar to images, you can add videos to a post.
    ///
    /// ```swift
    /// let videoURL = URL(string: "/path/to/file/beach.mp4")
    ///
    /// do {
    ///     let postResult = try await atProtoBluesky.createPostRecord(
    ///         text: "The waves on the beach are looking as beautiful as ever.",
    ///         embed: .video(video: Data(contentsOf: videoFileURL))
    ///     )
    ///
    ///     print(postResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// Only one video can be added to a post, can be 50 MB or less, and must use the .mp4 format.
    /// You can upload up to 25 videos per day and the 25 videos can't exceed a total of 500 MB
    /// for the day.
    ///
    /// ## External Links
    /// You can attach a website card to the post.
    ///
    /// ```swift
    /// Task {
    ///     print("Starting application...")
    ///
    ///     do {
    ///         let session = try await config.authenticate()
    ///
    ///         let externalLinkBuilder = ExternalLinkBuilder()
    ///
    ///         guard let link = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ") else { return }
    ///         let metadata = try await linkBuilder.grabMetadata(from: link)
    ///
    ///         let atProto = ATProtoKit(session: session)
    ///         let atProtoBluesky = ATProtoBluesky(atProtoKitInstance: atProto)
    ///
    ///         let postResult = try await atProtoBluesky.createPostRecord(
    ///             text: "Really glad to hear his talk in person!",
    ///             embed: .external(
    ///                 url: metadata.url,
    ///                 title: metadata.title,
    ///                 description: metadata.description ?? "No description given.",
    ///                 thumbnailURL: metadata.thumbnailURL
    ///             )
    ///         )
    ///
    ///         print("Post Result: \(postResult)")
    ///     } catch {
    ///         throw error
    ///     }
    /// }
    /// ```
    ///
    /// If there are any links in the post's text, the method will not convert it into a
    /// website card; you will need to manually achieve this.
    ///
    /// # Creating a Quote Post
    /// Quote posts are also embeds: you simply need to embed the record's strong reference to it.
    ///
    /// ```swift
    /// do {
    ///     let strongReference = ComAtprotoLexicon.Repository.StrongReference(recordURI: record.uri, cidHash: record.cid)
    ///
    ///     let postResult = try await atProtoBluesky.createPostRecord(
    ///         text: "Me whenever I look at my email:",
    ///         embed: .record(strongReference: strongReference)
    ///     )
    ///
    ///     print(postResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// Only one record can be embedded. This isn't limited to post records, though: you can embed
    /// any Bluesky-related record that you wish.
    ///
    /// # Creating a Reply
    /// To create a reply, pass the reply reference of the post's reply reference to the post record.
    ///
    /// ```swift
    /// do {
    ///     let replyReference = try await ATProtoTools().createReplyReference(
    ///         from: parentPost,
    ///         session: session
    ///     )
    ///
    ///     let postResult = try await atProtoBluesky.createPostRecord(
    ///         text: "I also like pancakes.",
    ///         replyTo: replyReference
    ///     )
    ///
    ///     print(postResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// If you want to create a thread of posts, use
    /// ``ATProtoTools/createReplyReference(from:session:)`` to create the reply reference and
    /// pass that over to `replyTo`:
    ///
    /// ```swift
    /// do {
    ///     let threadPost = try await atProtoBluesky.createPostRecord(
    ///         text: "I like waffles."
    ///     )
    ///
    ///     print("Replying...")
    ///
    ///     let firstReplyReference = try await ATProtoTools().createReplyReference(from: threadPost, session: session)
    ///
    ///     let threadPost2 = try await atProtoBluesky.createPostRecord(
    ///         text: "I also like pancakes.",
    ///         replyTo: firstReplyReference
    ///     )
    ///
    ///     print("Second reply...")
    ///
    ///     let secondReplyReference = try await ATProtoTools().createReplyReference(from: threadPost2, session: session)
    ///
    ///     let threadPost3 = try await atProtoBluesky.createPostRecord(
    ///         text: "I also like ice cream.",
    ///         replyTo: secondReplyReference
    ///     )
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - text: The text that's directly displayed in the post record. Current limit is
    ///   300 characters.
    ///   - inlineFacets: An array of URLs and index range numbers representing inline link facets.
    ///   Optional. Defaults to `nil`.
    ///   - locales: The languages the text is written in. Defaults to an empty array.
    ///   Current limit is 3 languages.
    ///   - replyTo: The post record that this record is replying to. Optional. Defaults to `nil`.
    ///   - embed: The embed container attached to the post record. Current items include
    ///   images, videos, external links, records, and post records with media. Optional.
    ///   Defaults to `nil`.
    ///   - labels: An array of labels made by the user. Optional. Defaults to `nil`.
    ///   - tags: An array of tags for the post record. Optional. Defaults to `nil`.
    ///   - creationDate: The date of the post record. Defaults to `Date.now`.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createPostRecord(
        text: String,
        inlineFacets: [(url: URL, startPosition: Int, endPosition: Int)]? = nil,
        locales: [Locale] = [],
        replyTo: AppBskyLexicon.Feed.PostRecord.ReplyReference? = nil,
        embed: EmbedIdentifier? = nil,
        labels: ATUnion.PostSelfLabelsUnion? = nil,
        tags: [String]? = nil,
        creationDate: Date = Date(),
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL else {
            throw ATRequestPrepareError.invalidPDS
        }

        // Truncate the number of characters to 300.
        let postText = text.truncated(toLength: 300)

        var facets = await ATFacetParser.parseFacets(from: postText, pdsURL: session.pdsURL ?? "https://bsky.social")
        if let inlineFacets {
            for (url, start, end) in inlineFacets {
                do {
                    let facet = try await ATFacetParser.createInlineLink(url: url, start: start, end: end)
                    facets.append(facet)
                } catch {
                    print("Failed to create inline link: \(error.localizedDescription)")
                }
            }
        }

        // Replies
        // Validate the reply reference if provided.
        var resolvedReplyTo: AppBskyLexicon.Feed.PostRecord.ReplyReference? = nil
        if let replyReference = replyTo {
            let isValid = await ATProtoTools().isValidReplyReference(replyReference, session: session)

            guard isValid else {
                throw ATProtoBlueskyError.invalidReplyReference(message: "The reply reference could not be validated.")
            }

            resolvedReplyTo = replyReference
        }

        // Locales
        let localeIdentifiers: [String]?
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            localeIdentifiers = locales.isEmpty ? nil : locales.compactMap {
                $0.language.languageCode?.identifier
            }
        } else {
            localeIdentifiers = locales.isEmpty ? nil : locales.compactMap { $0.languageCode }
        }

        // Embed
        var resolvedEmbed: ATUnion.PostEmbedUnion? = nil

        if let embedUnion = embed {
            do {
                switch embedUnion {
                    case .images(let images):
                        resolvedEmbed = try await uploadImages(
                            images,
                            pdsURL: sessionURL,
                            accessToken: session.accessToken
                        )
                    case .external(let url, let title, let description, let thumbnailImageURL):
                        resolvedEmbed = await buildExternalEmbed(
                            from: url,
                            title: title,
                            description: description,
                            thumbnailImageURL: thumbnailImageURL,
                            session: session
                        )
                    case .record(let record):
                        resolvedEmbed = try await addQuotePostToEmbed(record)
                    case .recordWithMedia(let record, let media):
                        let recordWithMediaDefinition = AppBskyLexicon.Embed.RecordWithMediaDefinition(
                            record: record,
                            media: media
                        )

                        resolvedEmbed = .recordWithMedia(recordWithMediaDefinition)
                    case .video(let video, let captions, let altText, let aspectRatio):
                        resolvedEmbed = try await buildVideo(
                            video,
                            with: captions,
                            altText: altText,
                            aspectRatio: aspectRatio,
                            pdsURL: sessionURL,
                            accessToken: session.accessToken
                        )
                }
            } catch {
                throw error
            }
        } else if let linkbuilder = self.linkBuilder {
            let resolvedLink = try? await grabURL(from: facets, linkbuilder: linkbuilder)

            if let resolvedLink = resolvedLink {
                resolvedEmbed = await buildExternalEmbed(
                    from: resolvedLink.url,
                    title: resolvedLink.title,
                    description: resolvedLink.description,
                    thumbnailImageURL: resolvedLink.thumbnailURL,
                    session: session
                )
            }
        }

        // Compiling all parts of the post into one.
        let postRecord = AppBskyLexicon.Feed.PostRecord(
            text: postText,
            facets: facets,
            reply: resolvedReplyTo,
            embed: resolvedEmbed,
            languages: localeIdentifiers,
            labels: labels,
            tags: tags,
            createdAt: creationDate
        )

        do {
            return try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.feed.post",
                recordKey: recordKey ?? nil,
                shouldValidate: shouldValidate,
                record: UnknownType.record(postRecord),
                swapCommit: swapCommit ?? nil
            )
        } catch {
            throw error
        }
    }
    
    /// Uploads images to the AT Protocol for attaching to a record at a later request.
    ///
    /// - Parameters:
    ///   - images: The ``ATProtoTools/ImageQuery`` that contains the image data. Current limit is
    ///   4 images.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///   - accessToken: The access token used to authenticate to the user.
    /// - Returns: An ``ATUnion/EmbedViewUnion``, which contains an array of
    /// ``AppBskyLexicon/Embed/ImagesDefinition``s for use in a record.
    ///
    /// - Important: Each image can only be 1 MB in size.
    public func uploadImages(_ images: [ATProtoTools.ImageQuery], pdsURL: String = "https://bsky.social",
                             accessToken: String) async throws -> ATUnion.PostEmbedUnion {
        var embedImages = [AppBskyLexicon.Embed.ImagesDefinition.Image]()

        for image in images {
            // Check if the image is too large.
            guard image.imageData.count <= 1_000_000 else {
                throw ATBlueskyError.imageTooLarge
            }

            // Upload the image, then get the server response.
            let blobReference = try await ATProtoKit(canUseBlueskyRecords: false).uploadBlob(
                pdsURL: pdsURL,
                accessToken: accessToken,
                filename: image.fileName,
                imageData: image.imageData
            )

            let embedImage = AppBskyLexicon.Embed.ImagesDefinition.Image(
                imageBlob: blobReference.blob,
                altText: image.altText ?? "",
                aspectRatio: image.aspectRatio
            )
            embedImages.append(embedImage)
        }

        return .images(AppBskyLexicon.Embed.ImagesDefinition(images: embedImages))
    }

    /// A structure that contains closed captioning information.
    ///
    /// The caption file should be in an .vtt format.
    public struct Caption: Codable {

        /// The caption file, in .vtt format.
        public let file: Data

        /// The language of the captions.
        public let language: Locale

        enum CodingKeys: String, CodingKey {
            case file
            case language = "lang"
        }
    }

    /// Uploads a video to the AT Protocol for attaching to a record at a later request.
    ///
    /// A maximum size of 50 MB is allowed to be uploaded. The video file must be in
    /// an .mp4 format. For the caption files, a maximum of 20 .vtt files can be add, and none
    /// can exceed 20 KB.
    ///
    /// - Important: If you're changing `pollingFrequency`, make sure it's a reasonable number.
    /// Failure to do so may result in being rate-limited.
    ///
    /// - Parameters:
    ///   - video: The video file itself.
    ///   - captions: An array of .vtt files for cloud captions in different languages. Optional.
    ///   - altText: Alt text for the video. Optional.
    ///   - aspectRatio: The aspect ratio of the video. Optional.
    ///   - pollingFrequency: The amount of time (in seconds) to poll for a job state update.
    ///   Defaults to 5 seconds.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `https://bsky.social`.
    ///   - accessToken: The access token used to authenticate to the user.
    /// - Returns: An ``ATUnion/EmbedViewUnion``, which contains an instance of
    /// ``AppBskyLexicon/Embed/VideoDefinition`` for use in a record.
    /// - Throws: Errors related to whether the video or caption file doesn't match the video file
    /// requirements, whether the files failed to upload, or whether anything related to the
    /// AT Protocol.
    public func buildVideo(_ video: Data, with captions: [Caption]? = nil, altText: String? = nil,
                           aspectRatio: AppBskyLexicon.Embed.AspectRatioDefinition? = nil, pollingFrequency: Int = 3, pdsURL: String = "https://bsky.social",
                           accessToken: String) async throws -> ATUnion.PostEmbedUnion {

        var videoBlob: ComAtprotoLexicon.Repository.UploadBlobOutput? = nil
        var captionReferences: [AppBskyLexicon.Embed.VideoDefinition.Caption] = []

        var videoJobStatus: AppBskyLexicon.Video.JobStatusDefinition? = nil

        // Check if the user can upload.
        do {
            let uploadLimitInformation = try await atProtoKitInstance.getUploadLimits()

            if uploadLimitInformation.canUpload == false {
                throw ATJobStatusError.permissionToUploadVideosDenied(message: "User account does not have permission to upload videos.")
            }

            if let remainingVideos = uploadLimitInformation.remainingDailyVideos, let remainingBytes = uploadLimitInformation.remainingDailyBytes {
                if remainingVideos == 0 || remainingBytes == 0 {
                    throw ATJobStatusError.videoLimitExceeded(message: "User account has reached the maximum number of videos they can upload.")
                }
            }
        } catch {
            throw error
        }


        // Upload the video and start the process.
        do {
            videoJobStatus = try await atProtoKitInstance.uploadVideo(video)
        } catch let uploadVideoError as ATAPIError {
            switch uploadVideoError {
                case .unauthorized(error: let error, wwwAuthenticate: let wwwAuthenticate):
                    throw ATAPIError.unauthorized(error: error, wwwAuthenticate: wwwAuthenticate)
                case .badRequest(error: let error),
                     .forbidden(error: let error),
                     .notFound(error: let error),
                     .methodNotAllowed(error: let error),
                     .payloadTooLarge(error: let error),
                     .upgradeRequired(error: let error),
                     .internalServerError(error: let error),
                     .methodNotImplemented(error: let error):
                    throw error
                case .tooManyRequests(error: let error, retryAfter: let retryAfter):
                    throw ATAPIError.tooManyRequests(error: error, retryAfter: retryAfter)
                case .badGateway:
                    throw ATAPIError.badGateway
                case .serviceUnavailable:
                    throw ATAPIError.serviceUnavailable
                case .gatewayTimeout:
                    throw ATAPIError.gatewayTimeout
                case .unknown(error: let error, errorCode: let errorCode, errorData: let errorData, httpHeaders: let httpHeaders):
                    throw ATAPIError.unknown(error: error, errorCode: errorCode, errorData: errorData, httpHeaders: httpHeaders)
            }
        } catch let uploadVideoError as ATJobStatusError {
            switch uploadVideoError {
                case .failedJob(error: let error):
                    if error.error == "already_exists" {
                        do {
                            videoJobStatus = try await atProtoKitInstance.getJobStatus(from: error.jobID).jobStatus
                        } catch {
                            throw error
                        }
                    }
                default:
                    throw ATAPIError.unknown(error: "An unknown error has occured.")
            }
        }

        guard let videoJobStatus = videoJobStatus else {
            throw ATAPIError.unknown(error: "Failed to initialize video job status.")
        }

        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        // Loop until the state says the upload was successful or a failure.
        var jobCompleted = false

        repeat {
            let jobStatus = try await atProtoKitInstance.getJobStatus(from: videoJobStatus.jobID)

            switch jobStatus.jobStatus.state {
                case .jobStateCompleted:
                    if let blob = jobStatus.jobStatus.blob {
                        videoBlob = blob
                        print("Blob successfully assigned.")
                        jobCompleted = true
                    }
                case .jobStateFailed:
                    throw ATJobStatusError.failedJob(error: jobStatus.jobStatus)
                default:
                    try await Task.sleep(nanoseconds: UInt64(pollingFrequency) * 1_000_000_000)
            }
        } while !jobCompleted

        guard let videoBlob = videoBlob else {
            throw ATAPIError.unknown(error: "Failed to retrieve video blob.")
        }

        // Upload captions.
        if let captions = captions {
            print("Beginning caption collection...")
            for caption in captions {
                let blobReference = try await ATProtoKit(canUseBlueskyRecords: false).uploadBlob(
                    pdsURL: pdsURL,
                    accessToken: accessToken,
                    filename: "\(ATProtoTools().generateRandomString())_caption.vtt",
                    imageData: caption.file
                )

                captionReferences.append(AppBskyLexicon.Embed.VideoDefinition.Caption(language: caption.language.identifier, fileBlob: blobReference.blob))
            }
        }

        let embedVideo = AppBskyLexicon.Embed.VideoDefinition(
            video: videoBlob,
            captions: captionReferences,
            altText: altText,
            aspectRatio: aspectRatio
        )

        print("Video is done being built. Time to go to the next step.")
        return .video(embedVideo)
    }

    /// Scraps the website for the required information in order to attach to a record's embed at a
    /// later request.
    ///
    /// - Parameters:
    ///   - url: The URL of the website.
    ///   - title: The title of the website.
    ///   - description: The description of the website.
    ///   - thumbnailImageURL: The URL of the thumbnail image. Optional.
    ///   - session: The ``UserSession`` object.
    /// - Returns: An ``ATUnion/EmbedViewUnion`` which contains an ``AppBskyLexicon/Embed/ExternalDefinition`` for use
    /// in a record.
    public func buildExternalEmbed(
        from url: URL,
        title: String,
        description: String?,
        thumbnailImageURL: URL? = nil,
        session: UserSession
    ) async -> ATUnion.PostEmbedUnion? {
        // Attempt to load the thumbnail image, if provided.
        let image: Data? = {
            guard let thumbnailImageURL,
                  let data = try? Data(contentsOf: thumbnailImageURL),
                  data.count <= 1_000_000 else { return nil }
            return data
        }()

        // Optional upload of the thumbnail image if it exists.
        var thumbnailImage: ComAtprotoLexicon.Repository.UploadBlobOutput? = nil

        if let pdsURL = session.pdsURL, let imageData = image {
            thumbnailImage = try? await ATProtoKit(canUseBlueskyRecords: false).uploadBlob(
                pdsURL: pdsURL,
                accessToken: session.accessToken,
                filename: "\(ATProtoTools().generateRandomString())_thumbnail.jpg",
                imageData: imageData
            ).blob

        } else {
            thumbnailImage = nil
        }


        let embedExternal = AppBskyLexicon.Embed.ExternalDefinition(
            external: AppBskyLexicon.Embed.ExternalDefinition.External(
                uri: url,
                title: title,
                description: description ?? "",
                thumbnailImage: thumbnailImage ?? nil
            )
        )
        return .external(embedExternal)
    }

    /// Grabs and validates a post record to attach to a record's embed at a later request.
    /// - Parameter strongReference: An object that contains the record's `recordURI` (URI) and
    /// the `cidHash` (CID) .
    /// - Returns: A strong reference, which contains a record's `recordURI` (URI) and the
    /// `cidHash` (CID) .
    ///
    /// - Throws: An ``ATProtoError``-conforming error type, depending on the issue. Go to
    /// ``ATAPIError`` and ``ATRequestPrepareError`` for more details.
    public func addQuotePostToEmbed(_ strongReference: ComAtprotoLexicon.Repository.StrongReference) async throws -> ATUnion.PostEmbedUnion {
        let record = try await ATProtoTools().fetchRecordForURI(strongReference.recordURI)
        let reference = ComAtprotoLexicon.Repository.StrongReference(recordURI: record.uri, cidHash: record.cid)
        let embedRecord = AppBskyLexicon.Embed.RecordDefinition(record: reference)

        return .record(embedRecord)
    }
    
    /// Represents the different types of content that can be embedded in a post record.
    ///  
    /// `EmbedIdentifier` provides a unified interface for specifying embeddable content,
    /// simplifying the process of attaching images, external links, other post records, or media
    /// to a post. By abstracting the details of each embed type, it allows methods like
    /// ``createPostRecord(text:inlineFacets:locales:replyTo:embed:labels:tags:creationDate:recordKey:shouldValidate:swapCommit:)``
    /// to handle the necessary operations (e.g., uploading, grabbing metadata, validation, etc.)
    /// behind the scenes, streamlining the embedding process.
    public enum EmbedIdentifier {

        /// Represents a set of images to be embedded in the post.
        ///
        /// - Parameter images: An array of ``ATProtoTools/ImageQuery`` objects, each containing
        /// the image data, metadata, and filenames of the image.
        case images(images: [ATProtoTools.ImageQuery])

        /// Represents a video to be embedded in the post.
        ///
        /// A maximum size of 50 MB is allowed to be uploaded. The video file must be in
        /// an .mp4 format. For the caption files, a maximum of 20 .vtt files can be add, and none
        /// can exceed 20 KB.
        ///
        /// - Parameters:
        ///   - video: The video file itself.
        ///   - captions: An array of captions for the video. Optional.
        ///   - altText: The alt text for the video. Optional.
        ///   - aspectRatio: The aspect ratio of the video. Optional.
        case video(video: Data, captions: [Caption]? = nil, altText: String? = nil, aspectoRatio: AppBskyLexicon.Embed.AspectRatioDefinition? = nil)

        /// Represents an external link to be embedded in the post.
        ///
        /// - Parameters:
        ///   - url: A `URL` pointing to the external content.
        ///   - title: The title of the external content.
        ///   - description: The description of the external content.
        ///   - thumbnailURL: The URL of the thumbnail image. Optional. Defaults to `nil`.
        case external(url: URL, title: String, description: String, thumbnailURL: URL? = nil)

        /// Represents another post record that is to be embedded within the current post.
        ///
        /// - Parameter strongReference: A `StrongReference` to the post record to be embedded,
        /// which contains a record's `recordURI` (URI) and the `cidHash` (CID) .
        case record(strongReference: ComAtprotoLexicon.Repository.StrongReference)

        /// Represents a post record accompanied by media, to be embedded within the current post.
        ///
        /// - Parameters:
        ///   - record: An `EmbedRecord`, representing the post to be embedded.
        ///   - media: A `MediaUnion`, representing the media content associated with the post.
        case recordWithMedia(record: AppBskyLexicon.Embed.RecordDefinition, media: ATUnion.RecordWithMediaUnion)
    }

    // MARK: Helper methods -

    /// Grabs a URL from an array of facets.
    ///
    /// - Parameters:
    ///   - facets: The array of facets.
    ///   - linkbuilder: The ``ATLinkBuilder`` object that's being passed through.
    /// - Returns: A tuple which contains the title, description, and (optionally) the
    /// thumbnail URL of the link.
    ///
    /// - Throws: The URL doesn't exist or is invalid.
    public func grabURL(
        from facets: [AppBskyLexicon.RichText.Facet],
        linkbuilder: ATLinkBuilder
    ) async throws -> (url: URL, title: String, description: String?, thumbnailURL: URL?) {
        // Try to get the first link from the array of facets.
        for facet in facets {
            // There will always only be one item in the array.
            if let linkFeature = facet.features.first,
               case let .link(link) = linkFeature,
               let url = URL(string: link.uri) {
                // Attempt to grab metadata using the link builder
                return try await linkbuilder.grabMetadata(from: url)
            }
        }
        // If no valid link is found, throw an appropriate error
        throw URLError(.badURL)
    }
}
