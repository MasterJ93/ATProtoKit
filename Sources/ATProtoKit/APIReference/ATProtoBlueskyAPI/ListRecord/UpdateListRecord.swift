//
//  UpdateListRecord.swift
//
//
//  Created by Christopher Jr Riley on 2025-02-28.
//

import Foundation

extension ATProtoBluesky {

    /// A convenience method to update a list record to the user account in Bluesky.
    /// 
    /// This can be used instead of creating your own method if you wish not to do so.
    /// 
    /// - Parameters:
    ///   - listURI: The URI of the post.
    ///   - name: The name of the list.
    ///   - listType: The list's type.
    ///   - description: The list's description. Optional. Defaults to `nil`.
    ///   - listAvatarImage: The avatar image of the list. Optional. Defaults to `nil`.
    ///   - labels: An array of labels made by the user. Optional. Defaults to `nil`.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func updateListRecord(
        listURI: String,
        name: String,
        listType: ListType,
        description: String? = nil,
        listAvatarImage: ATProtoTools.ImageQuery? = nil,
        labels: ATUnion.ListLabelsUnion? = nil
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session else {
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
        var postEmbed: ATUnion.PostEmbedUnion? = nil
        var avatarImage: ComAtprotoLexicon.Repository.UploadBlobOutput? = nil
        if let listAvatarImage = listAvatarImage {
            postEmbed = try await uploadImages(
                [listAvatarImage],
                pdsURL: sessionURL,
                accessToken: session.accessToken
            )

            switch postEmbed {
                case .images(let imagesDefinition):
                    let avatarImageContainer = imagesDefinition
                    avatarImage = avatarImageContainer.images[0].imageBlob
                default:
                    break
            }
        }

        let listRecord = AppBskyLexicon.Graph.ListRecord(
            purpose: listPurpose,
            name: nameText,
            description: descriptionText,
            descriptionFacets: descriptionFacets,
            avatarImageBlob: avatarImage,
            labels: labels,
            createdAt: Date()
        )

        do {
            let uri = try ATProtoTools().parseURI(listURI)

            guard try await atProtoKitInstance.getRepositoryRecord(
                from: uri.repository,
                collection: uri.collection,
                recordKey: uri.recordKey
            ).value != nil else {
                throw ATProtoBlueskyError.postNotFound(message: "List record (\(listURI)) not found.")
            }

            return try await atProtoKitInstance.putRecord(
                repository: session.sessionDID,
                collection: "app.bsky.graph.list",
                recordKey: uri.recordKey,
                record: UnknownType.record(listRecord)
            )
        } catch {
            throw error
        }
    }
}
