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
    /// When you want to erase a property, add the applicable cases and set them to `nil`.
    ///
    /// - Important: Don't make duplicates of the same case in the array. This method will
    /// only take the first instance; the rest will be discarded automatically.
    ///
    /// - Parameters:
    ///   - listURI: The URI of the list.
    ///   - replace: An array of properties where the list record would replace.
    /// - Returns: A strong reference, which contains the newly-created record's URI and CID hash.
    public func updateListRecord(
        listURI: String,
        replace: [UpdatedListRecordField]
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        guard let session = try await atProtoKitInstance.getUserSession() else {
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
        var uniqueFields: [UpdatedListRecordField] = []

        for field in replace {
            // If it reaches the limit, the loop will end early.
            if uniqueFields.count >= 5 { break }

            if !seenIdentifiers.contains(field.identifier) {
                seenIdentifiers.insert(field.identifier)
                uniqueFields.append(field)
            }
        }

        let uri = try ATProtoTools().parseURI(listURI)

        guard let record = try await atProtoKitInstance.getRepositoryRecord(
            from: uri.repository,
            collection: uri.collection,
            recordKey: uri.recordKey
        ).value,
              let list = record.getRecord(ofType: AppBskyLexicon.Graph.ListRecord.self) else {
            throw ATProtoBlueskyError.recordNotFound(message: "List record (\(listURI)) not found.")
        }

        // Make placeholder variables and hold the current record's values into them.
        // These variables will be part of the new record.
        var newListType: AppBskyLexicon.Graph.ListPurpose = list.purpose
        var newName: String = list.name
        var newDescription: String? = list.description
        var newDescriptionFacets: [AppBskyLexicon.RichText.Facet]? = list.descriptionFacets
        var newListAvatarImage: ComAtprotoLexicon.Repository.UploadBlobOutput? = list.avatarImageBlob
        var newLabels: AppBskyLexicon.Graph.ListRecord.LabelsUnion? = list.labels

        // Loop through each item of the array.
        for uniqueField in uniqueFields {
            // For each field, replace the values above with the applicable case.
            switch uniqueField {
                case .purpose(with: let listTypeField):
                    // Check which case was selected.
                    switch listTypeField {
                        case .moderation:
                            newListType = .modlist
                        case .curation:
                            newListType = .curatelist
                        case .reference:
                            newListType = .referencelist
                    }
                case .name(with: let nameField):
                    // Truncate the number of characters to 64.
                    newName = nameField.truncated(toLength: 64)
                case .description(with: let descriptionField):
                    if let descriptionField = descriptionField {
                        let truncatedDescription = descriptionField.truncated(toLength: 300)
                        let facets = await ATFacetParser.parseFacets(from: truncatedDescription, pdsURL: session.pdsURL ?? "https://bsky.social")

                        newDescription = truncatedDescription
                        newDescriptionFacets = facets
                    } else if descriptionField == nil || descriptionField?.count == 0 {
                        newDescription = nil
                        newDescriptionFacets = nil
                    }

                case .listAvatarImage(with: let listAvatarImageField):
                    // Check if the field is nil. If so, set the listAvatarImage variable to nil and break out of the case early.
                    if listAvatarImageField == nil {
                        newListAvatarImage = nil

                        break
                    }

                    if let listAvatarImageField = listAvatarImageField,
                       let keychain = sessionConfiguration?.keychainProtocol {
                        let accessToken = try await keychain.retrieveAccessToken()
                        let postEmbed = try await uploadImages(
                            [listAvatarImageField],
                            pdsURL: sessionURL,
                            accessToken: accessToken
                        )

                        switch postEmbed {
                            case .images(let imagesDefinition):
                                newListAvatarImage = imagesDefinition.images[0].imageBlob
                            default:
                                break
                        }
                    }
                case .labels(with: let labelsField):
                    newLabels = labelsField
            }
        }

        let listRecord = AppBskyLexicon.Graph.ListRecord(
            purpose: newListType,
            name: newName,
            description: newDescription,
            descriptionFacets: newDescriptionFacets,
            avatarImageBlob: newListAvatarImage,
            labels: newLabels,
            createdAt: Date()
        )

        do {
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

    /// An enumeration for updating the list record.
    public enum UpdatedListRecordField {

        /// The list's type.
        ///
        /// - Parameter with: The object to update the record with.
        case purpose(with: ListType)

        /// The name of the list.
        ///
        /// - Parameter with: The object to update the record with.
        case name(with: String)

        /// The list's description.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case description(with: String? = nil)

        /// The avatar image of the list.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case listAvatarImage(with: ATProtoTools.ImageQuery? = nil)

        /// An array of labels made by the user.
        ///
        /// - Parameter with: The object to update the record with. Optional. Defaults to `nil`.
        case labels(with: AppBskyLexicon.Graph.ListRecord.LabelsUnion? = nil)

        /// Identifies the field.
        var identifier: String {
            switch self {
                case .purpose: return "purpose"
                case .name: return "name"
                case .description: return "description"
                case .listAvatarImage: return "listAvatarImage"
                case .labels: return "labels"
            }
        }
    }
}
