//
//  UpdateProfileRecord.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-28.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to update a profile record to the user account in Bluesky.
    ///
    /// This can be used instead of creating your own method if you wish not to do so.
    ///  
    /// When you want to erase a property, add the applicable cases and set them to `nil`.
    ///  
    /// - Important: Don't make duplicates of the same case in the array. This method will
    /// only take the first instance; the rest will be discarded automatically.
    /// 
    /// - Parameters:
    ///   - profileURI: The URI of the profile.
    ///   - replace: An array of properties where the profile record would replace.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func updateProfileRecord(
        profileURI: String,
        replace: [UpdatedProfileRecordField]
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession(),
              let keychain = sessionConfiguration?.keychainProtocol else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL else {
            throw ATRequestPrepareError.invalidPDS
        }

        if replace.count == 0 {
            throw ATProtoBlueskyError.emptyReplaceArray(message: "The 'replace' argument must contain at least one value.")
        }

        // Check for duplicates.
        var seenIdentifiers = Set<String>()
        var uniqueFields: [UpdatedProfileRecordField] = []

        for field in replace {
            // If it reaches the limit, the loop will end early.
            if uniqueFields.count >= 7 { break }

            if !seenIdentifiers.contains(field.identifier) {
                seenIdentifiers.insert(field.identifier)
                uniqueFields.append(field)
            }
        }

        let uri = try ATProtoTools().parseURI(profileURI)

        guard let record = try await atProtoKitInstance.getRepositoryRecord(
            from: uri.repository,
            collection: uri.collection,
            recordKey: uri.recordKey
        ).value,
              let profile = record.getRecord(ofType: AppBskyLexicon.Actor.ProfileRecord.self) else {
            throw ATProtoBlueskyError.recordNotFound(message: "Profile record (\(profileURI)) not found.")
        }

        var newDisplayName: String? = profile.displayName
        var newDescription: String? = profile.description
        var newAvatarImage: ComAtprotoLexicon.Repository.UploadBlobOutput? = profile.avatarBlob
        var newBannerImage: ComAtprotoLexicon.Repository.UploadBlobOutput? = profile.bannerBlob
        var newLabels: [ComAtprotoLexicon.Label.SelfLabelsDefinition]? = profile.labels
        var newJoinedViaStarterPack: ComAtprotoLexicon.Repository.StrongReference? = profile.joinedViaStarterPack
        var newPinnedPost: ComAtprotoLexicon.Repository.StrongReference? = profile.pinnedPost

        for uniqueField in uniqueFields {
            let accessToken = try keychain.retrieveAccessToken()

            switch uniqueField {
                case .displayName(let displayNameField):
                    // Check if the field is nil. If so, set the displayName variable to nil and break out of the case early.
                    if displayNameField == nil {
                        newDisplayName = nil

                        break
                    }

                    newDisplayName = displayNameField?.truncated(toLength: 64)
                case .description(let descriptionField):
                    // Check if the field is nil. If so, set the descriptionField variable to nil and break out of the case early.
                    if descriptionField == nil {
                        newDescription = nil

                        break
                    }

                    newDescription = descriptionField?.truncated(toLength: 256)
                case .avatarImage(let avatarImageField):
                    // Check if the field is nil. If so, set the avatarImage variable to nil and break out of the case early.
                    if avatarImageField == nil {
                        newAvatarImage = nil

                        break
                    }

                    if let avatarImageField = avatarImageField {
                        let postEmbed = try await uploadImages(
                            [avatarImageField],
                            pdsURL: sessionURL,
                            accessToken: accessToken
                        )

                        switch postEmbed {
                            case .images(let imagesDefinition):
                                newAvatarImage = imagesDefinition.images[0].imageBlob
                            default:
                                break
                        }
                    }
                case .bannerImage(let bannerImageField):
                    // Check if the field is nil. If so, set the bannerImage variable to nil and break out of the case early.
                    if bannerImageField == nil {
                        newBannerImage = nil

                        break
                    }

                    if let bannerImageField = bannerImageField {
                        let postEmbed = try await uploadImages(
                            [bannerImageField],
                            pdsURL: sessionURL,
                            accessToken: accessToken
                        )

                        switch postEmbed {
                            case .images(let imagesDefinition):
                                newBannerImage = imagesDefinition.images[0].imageBlob
                            default:
                                break
                        }
                    }
                case .labels(let labelsField):
                    // Check if the field is nil. If so, set the labels variable to nil and break out of the case early.
                    if labelsField == nil {
                        newLabels = nil

                        break
                    }

                    newLabels = labelsField
                case .joinedViaStarterPack(let joinedViaStarterPackField):
                    // Check if the field is nil. If so, set the joinedViaStarterPack variable to nil and break out of the case early.
                    if joinedViaStarterPackField == nil {
                        newJoinedViaStarterPack = nil

                        break
                    }

                    newJoinedViaStarterPack = joinedViaStarterPackField
                case .pinnedPost(let pinnedPostField):
                    // Check if the field is nil. If so, set the pinnedPost variable to nil and break out of the case early.
                    if pinnedPostField == nil {
                        newPinnedPost = nil

                        break
                    }

                    newPinnedPost = pinnedPostField
            }
        }

        let profileRecord = AppBskyLexicon.Actor.ProfileRecord(
            displayName: newDisplayName,
            description: newDescription,
            avatarBlob: newAvatarImage,
            bannerBlob: newBannerImage,
            labels: newLabels,
            joinedViaStarterPack: newJoinedViaStarterPack,
            pinnedPost: newPinnedPost,
            createdAt: Date()
        )

        do {
            return try await atProtoKitInstance.putRecord(
                repository: session.sessionDID,
                collection: "app.bsky.actor.profile",
                recordKey: uri.recordKey,
                record: UnknownType.record(profileRecord)
            )
        } catch {
            throw error
        }
    }

    /// An enumeration for updating the profile record.
    public enum UpdatedProfileRecordField {

        /// The display name of the profile.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case displayName(with: String? = nil)

        /// A description for the profile.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case description(with: String? = nil)

        /// An image used for the profile picture.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case avatarImage(with: ATProtoTools.ImageQuery? = nil)

        /// An image used for the banner image
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case bannerImage(with: ATProtoTools.ImageQuery? = nil)

        /// An array of user-defined labels.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case labels(with: [ComAtprotoLexicon.Label.SelfLabelsDefinition]? = nil)

        /// A strong reference to the starter pack the user used to join Bluesky.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case joinedViaStarterPack(with: ComAtprotoLexicon.Repository.StrongReference? = nil)

        /// A strong reference to a post the user account has.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case pinnedPost(with: ComAtprotoLexicon.Repository.StrongReference? = nil)

        var identifier: String {
            switch self {
                case .displayName: return "displayName"
                case .description: return "description"
                case .avatarImage: return "avatarImage"
                case .bannerImage: return "bannerImage"
                case .labels: return "labels"
                case .joinedViaStarterPack: return "joinedViaStarterPack"
                case .pinnedPost: return "pinnedPost"
            }
        }
    }
}
