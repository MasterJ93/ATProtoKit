//
//  CreateListRecord.swift
//  
//
//  Created by Christopher Jr Riley on 2024-06-01.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to create a list record to the user account in Bluesky.
    /// 
    /// This can be used instead of creating your own method if you wish not to do so.
    ///
    /// # Creating a List
    ///
    /// After you authenticate into Bluesky, you can create a list by using the `name` and
    /// `listType` arguments:
    ///
    /// ```swift
    /// do {
    ///     let listResult = try await atProtoBluesky.createListRecord(
    ///         named: "Book Authors",
    ///         ofType: .reference
    ///     )
    ///
    ///     print(listResult)
    /// } catch {
    ///     throw error
    /// }
    /// ```
    ///
    /// You can optionally add a description and avatar image for the list.
    ///
    /// - Note: Names can be up to 64 characters long. \
    /// \
    /// Descriptions can be up to 300 characters long.\
    /// \
    /// List avatar images can be either .jpg or .png and can be up to 1 MB large.
    ///
    /// # Types of Lists
    ///
    /// There are three types of lists that can be created:
    /// - Moderation lists: These are lists where the user accounts listed will be muted
    /// or blocked.
    /// - Curated lists: These are lists where the user accounts listed are used for curation:
    /// things like allowlists for interaction or regular feeds.
    /// - Reference feeds: These are lists where the user accounts listed will be used as a
    /// reference, such as with a starter pack.
    ///
    /// - Parameters:
    ///   - name: The name of the list.
    ///   - listType: The list's type.
    ///   - description: The list's description. Optional. Defaults to `nil`.
    ///   - listAvatarImage: The avatar image of the list. Optional. Defaults to `nil`.
    ///   - labels: An array of labels made by the user. Optional. Defaults to `nil`.
    ///   - creationDate: The date of the post record. Defaults to `Date.now`.
    ///   - recordKey: The record key of the collection. Optional. Defaults to `nil`.
    ///   - shouldValidate: Indicates whether the record should be validated. Optional.
    ///   Defaults to `true`.
    ///   - swapCommit: Swaps out an operation based on the CID. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func createListRecord(
        named name: String,
        ofType listType: ListType,
        description: String? = nil,
        listAvatarImage: ATProtoTools.ImageQuery? = nil,
        labels: ATUnion.ListLabelsUnion? = nil,
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

        // listPurpose
        let listPurpose: AppBskyLexicon.Graph.ListPurpose
        switch listType {
            case .moderation:
                listPurpose = .modlist
            case .curation:
                listPurpose = .curatelist
            case .reference:
                listPurpose = .referencelist
        }

        // name
        // Truncate the number of characters to 64.
        let nameText = name.truncated(toLength: 64)

        // description and descriptionFacets
        var descriptionText: String? = nil
        var descriptionFacets: [AppBskyLexicon.RichText.Facet]? = nil

        if let description = description {
            // Truncate the number of characters to 300.
            let truncatedDescriptionText = description.truncated(toLength: 300)
            descriptionText = truncatedDescriptionText

            let facets = await ATFacetParser.parseFacets(from: truncatedDescriptionText, pdsURL: session.pdsURL ?? "https://bsky.social")
            descriptionFacets = facets
        }

        // listAvatarImage
        var avatarImage: ComAtprotoLexicon.Repository.UploadBlobOutput? = nil
        if let listAvatarImage = listAvatarImage {
            if let keychain = sessionConfiguration?.keychainProtocol {
                let accessToken = try await keychain.retrieveAccessToken()
                let postEmbed = try await uploadImages(
                    [listAvatarImage],
                    pdsURL: sessionURL,
                    accessToken: accessToken
                )

                switch postEmbed {
                    case .images(let imagesDefinition):
                        let avatarImageContainer = imagesDefinition
                        avatarImage = avatarImageContainer.images[0].imageBlob
                    default:
                        break
                }
            }
        }

        let listRecord = AppBskyLexicon.Graph.ListRecord(
            purpose: listPurpose,
            name: nameText,
            description: descriptionText,
            descriptionFacets: descriptionFacets,
            avatarImageBlob: avatarImage,
            labels: labels,
            createdAt: creationDate
        )

        do {
            return try await atProtoKitInstance.createRecord(
                repositoryDID: session.sessionDID,
                collection: "app.bsky.graph.list",
                recordKey: recordKey ?? nil,
                shouldValidate: shouldValidate,
                record: UnknownType.record(listRecord),
                swapCommit: swapCommit ?? nil
            )
        } catch {
            throw error
        }
    }

    /// The list's type.
    public enum ListType {

        /// Indicates the list is used for muting or blocking the list of user accounts.
        case moderation

        /// Indicates the list is used for curation purposes, such as list feeds or
        /// interaction gating.
        case curation

        /// Indicates the list is used for reference purposes (such as within a starter pack).
        case reference
    }
}
