//
//  CreateProfileRecord.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-28.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to create a profile record to the user account in Bluesky.
    /// 
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// # Creating a Profile
    ///
    /// After you authenticate into Bluesky, you can create a profile. You don't have to enter
    /// anything: Bluesky will still accept it:
    /// ```swift
    /// do {
    ///     let profileResult = try await atProtoBluesky.createProfileRecord()
    ///
    ///     print(profileResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// # Adding Details
    ///
    /// In most cases, however, you will want to add different details. You can enter in the
    /// display name and description using the `displayName` and `description`
    /// arguments respectively:
    ///
    /// ```swift
    /// do {
    ///     let profileResult = try await atProtoBluesky.createProfileRecord(
    ///         displayName: "Alexy Carter",
    ///         description: "Big fan of music, movies, and weekend road trips. Just trying to enjoy life one day at a time."
    ///     )
    ///
    ///     print(profileResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    /// - Note: You can have up to 64 characters for the display name and up to 300 characters for
    /// the description.
    ///
    /// You can also add the images for profile pictures and banners:
    /// ```swift
    /// do {
    ///     let profileResult = try await atProtoBluesky.createProfileRecord(
    ///         displayName: "Alexy Carter",
    ///         description: "Big fan of music, movies, and weekend road trips. Just trying to enjoy life one day at a time.",
    ///         avatarImage: ATProtoTools.ImageQuery(
    ///             imageData: Data(contentsOf: "/path/to/file/alexycarter_avatar.jpg"),
    ///             fileName: "alexycarter_profile.jpg",
    ///             altText: "Image of me with glasses, with my dog."
    ///         ),
    ///         bannerImage: ATProtoTools.ImageQuery(
    ///             imageData: Data(contentsOf: "/path/to/file/alexycarter_banner.jpg"),
    ///             fileName: alexycarter_banner.jpg,
    ///             altText: "A baseball stadium."
    ///         )
    ///     )
    ///
    ///     print(profileResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Note: Both the avatar and banner images can be up to 1 MB in size. You can upload either
    /// .jpg or .png.
    ///
    /// # Pinning and Unpinning Posts
    ///
    /// If you want to pin a post, create a strong reference and attach it to the
    /// `pinnedPost` argument. The easiest way to do this is to get the URI of the post, then use
    /// ``ATProtoTools/createStrongReference(from:pdsURL:)``:
    ///
    /// ```swift
    /// do {
    ///     let pinnedPostStrongReference = ATProtoTools.createStrongReference(from: uri)
    ///     let profileResult = try await atProtoBluesky.createProfileRecord(
    ///         displayName: "Alexy Carter",
    ///         description: "Big fan of music, movies, and weekend road trips. Just trying to enjoy life one day at a time.",
    ///         avatarImage: ATProtoTools.ImageQuery(
    ///             imageData: Data(contentsOf: "/path/to/file/alexycarter_avatar.jpg"),
    ///             fileName: "alexycarter_profile.jpg",
    ///             altText: "Image of me with glasses, with my dog."
    ///         ),
    ///         bannerImage: ATProtoTools.ImageQuery(
    ///             imageData: Data(contentsOf: "/path/to/file/alexycarter_banner.jpg"),
    ///             fileName: alexycarter_banner.jpg,
    ///             altText: "A baseball stadium."
    ///         ),
    ///         pinnedPost: pinnedPostStrongReference
    ///     )
    ///
    ///     print(profileResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// If you want to unpin the post, simply update the profile record and set
    /// `pinnedPost` to `nil`.
    ///
    /// - Parameters:
    ///   - displayName: A display name for the profile. Optional. Defaults to `nil`.
    ///   - description: A description for the profile. Optional. Defaults to `nil`.
    ///   - avatarImage: An image used for the profile picture. Optional. Defaults to `nil`.
    ///   - bannerImage: An image used for the banner image. Optional,Defaults to `nil`.
    ///   - labels: An array of user-defined labels. Optional. Defaults to `nil`.
    ///   - joinedViaStarterPack: A strong reference to the starter pack the user used to
    ///   join Bluesky.
    ///   - pinnedPost: A strong reference to a post the user account has. Optional.
    ///   Defaults to `nil`.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createProfileRecord(
        with displayName: String? = nil,
        description: String? = nil,
        avatarImage: ATProtoTools.ImageQuery? = nil,
        bannerImage: ATProtoTools.ImageQuery? = nil,
        labels: [ComAtprotoLexicon.Label.SelfLabelsDefinition]? = nil,
        joinedViaStarterPack: ComAtprotoLexicon.Repository.StrongReference? = nil,
        pinnedPost: ComAtprotoLexicon.Repository.StrongReference? = nil,
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL else {
            throw ATRequestPrepareError.invalidPDS
        }

        // displayText
        var displayNameText: String? = nil
        if let displayName = displayName {
            displayNameText = displayName.truncated(toLength: 64)
        }

        // description
        var descriptionText: String? = nil
        if let description = description {
            descriptionText = description.truncated(toLength: 256)
        }

        // avatarImage
        var profileAvatarImage: ComAtprotoLexicon.Repository.UploadBlobOutput? = nil
        let accessToken = try await keychain.retrieveAccessToken()

        if let avatarImage = avatarImage {
            let postEmbed = try await uploadImages(
                [avatarImage],
                pdsURL: sessionURL,
                accessToken: accessToken
            )

            switch postEmbed {
                case .images(let imagesDefinition):
                    let avatarImageContainer = imagesDefinition
                    profileAvatarImage = avatarImageContainer.images[0].imageBlob
                default:
                    break
            }
        }

        // bannerImage
        var profileBannerImage: ComAtprotoLexicon.Repository.UploadBlobOutput? = nil
        if let bannerImage = bannerImage {
            let postEmbed = try await uploadImages(
                [bannerImage],
                pdsURL: sessionURL,
                accessToken: accessToken
            )

            switch postEmbed {
                case .images(let imagesDefinition):
                    let bannerImageContainer = imagesDefinition
                    profileBannerImage = bannerImageContainer.images[0].imageBlob
                default:
                    break
            }
        }

        // labels
        var labelsArray: [AppBskyLexicon.Actor.ProfileRecord.LabelsUnion]? = nil
        if let labels = labels {
            for label in labels {
                labelsArray?.append(.selfLabel(label))
            }
        }

        let profileRecord = AppBskyLexicon.Actor.ProfileRecord(
            displayName: displayNameText,
            description: descriptionText,
            avatarBlob: profileAvatarImage,
            bannerBlob: profileBannerImage,
            labels: labelsArray,
            joinedViaStarterPack: joinedViaStarterPack,
            pinnedPost: pinnedPost,
            createdAt: Date()
        )

        do {
            return try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.actor.profile",
                recordKey: recordKey ?? nil,
                shouldValidate: shouldValidate,
                record: UnknownType.record(profileRecord),
                swapCommit: swapCommit ?? nil
            )
        } catch {
            throw error
        }
    }
}
