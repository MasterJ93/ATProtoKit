//
//  CreateLinkRecord.swift
//  ATProtoKit
//
//  Created by Keisuke Chinone on 2026-11-28.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ATProtoBluesky {

    /// A convenience method to create a link record to the user account in Bluesky.
    ///
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// # Creating a Link
    ///
    /// After you authenticate into Bluesky, you can create a link by using the `url` argument:
    ///
    /// ```swift
    /// do {
    ///     let linkResult = try await atProtoBluesky.createLinkRecord(
    ///         url: "https://example.com"
    ///     )
    ///
    ///     print(linkResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// You can optionally add a title and icon image for the link.
    ///
    /// - Note: Titles can be up to 40 characters long. \
    /// \
    /// Link icon images can be either .jpg, .png, or .webp and can be up to 100 KB large.
    ///
    /// # Showing the Link on the Profile
    ///
    /// Creating a link record doesn't show it on the profile by itself. To show it, attach the
    /// strong reference to the profile record. You can do this with the `links` argument of
    /// ``createProfileRecord(with:description:pronouns:websiteURL:avatarImage:bannerImage:labels:joinedViaStarterPack:pinnedPost:links:recordKey:shouldValidate:swapCommit:)``,
    /// or with ``UpdatedProfileRecordField/links(with:)`` in
    /// ``updateProfileRecord(profileURI:replace:)``:
    ///
    /// ```swift
    /// do {
    ///     let linkResult = try await atProtoBluesky.createLinkRecord(
    ///         url: "https://example.com",
    ///         title: "My Website"
    ///     )
    ///
    ///     let profileResult = try await atProtoBluesky.updateProfileRecord(
    ///         profileURI: profileURI,
    ///         replace: [
    ///             .links(with: [linkResult])
    ///         ]
    ///     )
    ///
    ///     print(profileResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - url: The link destination, an https URL.
    ///   - title: The label for the link. Optional. Defaults to `nil`.
    ///   - iconImage: The icon image of the link. Optional. Defaults to `nil`.
    ///   - creationDate: The date of the link record. Defaults to `Date.now`.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createLinkRecord(
        url: String,
        title: String? = nil,
        iconImage: ATProtoTools.ImageQuery? = nil,
        creationDate: Date = Date(),
        recordKey: String? = nil,
        shouldValidate: Bool? = true,
        swapCommit: String? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
            throw ATRequestPrepareError.missingActiveSession
        }

        guard let sessionURL = session.pdsURL else {
            throw ATRequestPrepareError.invalidPDS
        }

        // title
        var titleText: String? = nil
        if let title = title {
            // Truncate the number of characters to 40.
            titleText = title.truncated(toLength: 40)
        }

        // iconImage
        var icon: ComAtprotoLexicon.Repository.UploadBlobOutput? = nil
        if let iconImage = iconImage {
            let postEmbed = try await uploadImages(
                [iconImage],
                pdsURL: sessionURL,
                maxSize: AttachmentLexiconLimit.linkIcon
            )

            switch postEmbed {
                case .images(let imagesDefinition):
                    let iconImageContainer = imagesDefinition
                    icon = iconImageContainer.images[0].imageBlob
                default:
                    break
            }
        }

        let linkRecord = AppBskyLexicon.Actor.LinkRecord(
            url: url,
            title: titleText,
            iconBlob: icon,
            createdAt: creationDate
        )

        do {
            let record = try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.actor.link",
                recordKey: recordKey ?? nil,
                shouldValidate: shouldValidate,
                record: UnknownType.record(linkRecord),
                swapCommit: swapCommit ?? nil
            )

            try await Task.sleep(nanoseconds: 500_000_000)

            return record
        } catch {
            throw error
        }
    }
}
