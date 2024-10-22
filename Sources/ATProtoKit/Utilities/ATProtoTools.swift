//
//  ATProtoTools.swift
//
//
//  Created by Christopher Jr Riley on 2024-04-29.
//

import Foundation
#if canImport(Regex)
import Regex
#endif


/// A group of methods for miscellaneous aspects of ATProtoKit.
///
/// These methods are useful for anything that's too small or too niche to be added elsewhere.
/// This may also include methods directly related to the AT Protocol.
///
/// If a method is better suited elsewhere, then it will be re-created to a more appropriate
/// `class`. The version in here will then become deprecated, and then later removed in a
/// future update.
///
/// - Important: The rule where the method becomes deprecated will be active either
/// when version 1.0 is launched or `ATProtoTools` is stabilized, whichever comes first.
/// Until then, if a method is better suited elsewhere, it will be immediately moved.
public class ATProtoTools {

    /// Determines whether the reply reference is valid.
    ///
    /// - Parameters:
    ///   - reference: The reply reference object to check for validity.
    ///   - session: The ``UserSession`` instance in relation to the reply. Optional.
    ///   Defaults to `nil`.
    /// - Returns: `true` if the references are valid, or `false` if one or both references
    /// are invalid.
    public func isValidReplyReference(_ reference: AppBskyLexicon.Feed.PostRecord.ReplyReference, session: UserSession? = nil) async -> Bool {
        var rootRecord: RecordQuery? = nil
        var parentRecord: RecordQuery? = nil

        // Check if the root record is valid.
        do {
            rootRecord = try parseURI(reference.root.recordURI)

            guard let repository = rootRecord?.repository,
                  let collection = rootRecord?.collection,
                  let recordKey = rootRecord?.recordKey else {
                return false
            }

            _ = try await ATProtoKit().getRepositoryRecord(
                from: repository,
                collection: collection,
                recordKey: recordKey,
                pdsURL: session?.pdsURL
            )
        } catch {
            return false
        }

        // Check if the parent record is valid.
        do {
            parentRecord = try parseURI(reference.parent.recordURI)

            guard let repository = parentRecord?.repository,
                  let collection = parentRecord?.collection,
                  let recordKey = parentRecord?.recordKey else {
                return false
            }

            _ = try await ATProtoKit().getRepositoryRecord(
                from: repository,
                collection: collection,
                recordKey: recordKey,
                pdsURL: session?.pdsURL
            )
        } catch {
            return false
        }

        return true
    }

    /// A utility method for converting a ``RecordOutput`` into a ``ReplyReference``.
    ///
    /// - Parameters:
    ///   - strongReference: The strong reference used to create the reply reference.
    ///   - session: The ``UserSession`` instance in relation to the reply. Optional.
    ///   Defaults to `nil`.
    /// - Returns: A ``ReplyReference`` from the given post record.
    /// - Throws: Either the ``ATAPIError`` error, or that the reply reference is invalid.
    public func createReplyReference(
        from strongReference: ComAtprotoLexicon.Repository.StrongReference,
        session: UserSession
    ) async throws -> AppBskyLexicon.Feed.PostRecord.ReplyReference {
        do {
            // Parse the URI to retrieve post data.
            let recordQuery = try parseURI(
                strongReference.recordURI,
                pdsURL: session.pdsURL ?? "https://bsky.social"
            )

            let repository = recordQuery.repository
            let collection = recordQuery.collection
            let recordKey = recordQuery.recordKey

            let record = try await ATProtoKit().getRepositoryRecord(
                from: repository,
                collection: collection,
                recordKey: recordKey,
                pdsURL: session.pdsURL
            )

            guard let postRecord = record.value?.getRecord(ofType: AppBskyLexicon.Feed.PostRecord.self) else {
                throw ATProtoBlueskyError.invalidReplyReference(
                    message: "Failed to parse the post record."
                )
            }

            // Check if the current post is a reply to something.
            if let reply = postRecord.reply {
                // Attempt to find the true root reference.
                let rootReference = try await resolveRoot(from: reply.root, session: session)

                return AppBskyLexicon.Feed.PostRecord.ReplyReference(
                    root: rootReference,
                    parent: strongReference
                )
            } else {
                // If there's no reply, treat this post as both the root and the parent.
                return AppBskyLexicon.Feed.PostRecord.ReplyReference(
                    root: strongReference,
                    parent: strongReference
                )
            }
        } catch {
            throw error
        }
    }


    /// Resolves the root reference of a post thread
    ///
    /// This is mainly used if the record is part of a reply thread and it's at least two levels
    /// deep from the root record.
    ///
    /// - Parameters:
    ///   - reference: The `StrongReference` of the post record to start the search.
    ///   - session: The `UserSession` instance used for API communication.
    ///
    /// - Returns: The `StrongReference` representing the root of the thread.
    ///
    /// - Throws: An error if the record cannot be fetched or parsed.
    private func resolveRoot(
        from reference: ComAtprotoLexicon.Repository.StrongReference,
        session: UserSession
    ) async throws -> ComAtprotoLexicon.Repository.StrongReference {
        // Parse the URI to retrieve the post data.
        let recordQuery = try parseURI(reference.recordURI, pdsURL: session.pdsURL ?? "https://bsky.social")

        // Fetch the post record from the repository.
        let record = try await ATProtoKit().getRepositoryRecord(
            from: recordQuery.repository,
            collection: recordQuery.collection,
            recordKey: recordQuery.recordKey,
            pdsURL: session.pdsURL
        )

        guard let postRecord = record.value?.getRecord(ofType: AppBskyLexicon.Feed.PostRecord.self) else {
            throw ATProtoBlueskyError.invalidReplyReference(
                message: "Failed to parse the post record."
            )
        }

        // If this post has a root reference, return it immediately.
        if let reply = postRecord.reply {
            print("Found root reference. Skipping further recursion.")
            return reply.root
        }

        // If no root reference exists, return the provided reference as the root.
        return reference
    }



    /// Resolves the reply references to prepare them for a later post record request.
    ///
    /// - Parameters:
    ///   - parentURI: The URI of the post record the current one is directly replying to.
    ///   - session: The ``UserSession`` instance in relation to the reply. Optional.
    ///   Defaults to `nil`.
    /// - Returns: A ``AppBskyLexicon/Feed/PostRecord/ReplyReference``.
    public func resolveReplyReferences(parentURI: String, session: UserSession? = nil) async throws -> AppBskyLexicon.Feed.PostRecord.ReplyReference {
        let threadRecords = try await fetchRecordForURI(parentURI, session: session)

        guard let parentRecord = threadRecords.value else {
            return createReplyReference(from: threadRecords)
        }

        var replyReference: AppBskyLexicon.Feed.PostRecord.ReplyReference?

        switch parentRecord {
            case .unknown(let unknown):
                replyReference = try decodeReplyReference(from: unknown)
            default:
                break
        }

        if let replyReference = replyReference {
            return try await getReplyReferenceWithRoot(replyReference)
        }

        return createReplyReference(from: threadRecords)
    }

    private func decodeReplyReference(from unknown: [String: Any]) throws -> AppBskyLexicon.Feed.PostRecord.ReplyReference? {
        if let replyData = unknown["reply"] as? [String: Any] {
            let jsonData = try JSONSerialization.data(withJSONObject: replyData, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(AppBskyLexicon.Feed.PostRecord.ReplyReference.self, from: jsonData)
        }
        return nil
    }

    private func getReplyReferenceWithRoot(
        _ replyReference: AppBskyLexicon.Feed.PostRecord.ReplyReference) async throws -> AppBskyLexicon.Feed.PostRecord.ReplyReference {
            let rootRecord = try await fetchRecordForURI(replyReference.root.recordURI)
            let parentRecord = try await fetchRecordForURI(replyReference.parent.recordURI)

        if let rootReferenceValue = rootRecord.value {
            switch rootReferenceValue {
                case .unknown:
                    return AppBskyLexicon.Feed.PostRecord.ReplyReference(root: replyReference.root, parent: replyReference.parent)
                default:
                    return AppBskyLexicon.Feed.PostRecord.ReplyReference(root: replyReference.root, parent: replyReference.parent)
            }
        }
        return AppBskyLexicon.Feed.PostRecord.ReplyReference(root: replyReference.root, parent: replyReference.parent)
    }

    /// Gets a record from the user's repository.
    ///
    /// - Parameters:
    ///   - uri: The URI of the record.
    ///   - session: The ``UserSession`` instance in relation to the reply. Optional.
    ///   Defaults to `nil`.
    /// - Returns: A ``ComAtprotoLexicon/Repository/GetRecordOutput``
    public func fetchRecordForURI(_ uri: String, session: UserSession? = nil) async throws -> ComAtprotoLexicon.Repository.GetRecordOutput {
        let query = try parseURI(uri)

        do {
            let record = try await ATProtoKit().getRepositoryRecord(from: query.repository, collection: query.collection, recordKey: query.recordKey, pdsURL: session?.pdsURL)

            return record
        } catch {
            throw error
        }
    }

    /// A utility method for converting a ``RecordOutput`` into a ``ReplyReference``.
    ///
    /// - Parameter record: The record to convert.
    /// - Returns: A ``ReplyReference``.
    private func createReplyReference(from record: ComAtprotoLexicon.Repository.GetRecordOutput) -> AppBskyLexicon.Feed.PostRecord.ReplyReference {
        let reference = ComAtprotoLexicon.Repository.StrongReference(recordURI: record.recordURI, cidHash: record.recordCID)

        return AppBskyLexicon.Feed.PostRecord.ReplyReference(root: reference, parent: reference)
    }

    /// Parses the URI in order to get a ``RecordQuery``.
    ///
    /// There are two formats of URIs: the ones that have the `at://` protocol, and the ones that
    /// start off with the URL of the Personal Data Server (PDS). Regardless of option, this method
    /// should be able to parse
    /// them and return a proper ``RecordQuery``. However, it's still important to validate the
    /// record by using ``ATProtoKit/ATProtoKit/getRepositoryRecord(from:pdsURL:)``.
    /// - Parameters:
    ///   - uri: The URI to parse.
    ///   - pdsURL: The URL of the Personal Data Server (PDS). Defaults to `nil`.
    /// - Returns: A ``RecordQuery``.
    public func parseURI(_ uri: String,
                           pdsURL: String = "https://bsky.app") throws -> RecordQuery {
        if uri.hasPrefix("at://") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 4 else { throw ATRequestPrepareError.invalidFormat }

            return ATProtoTools.RecordQuery(repository: components[1], collection: components[2], recordKey: components[3])
        } else if uri.hasPrefix("\(pdsURL)/") {
            let components = uri.split(separator: "/").map(String.init)
            guard components.count >= 6 else {
                throw ATRequestPrepareError.invalidFormat
            }

            let record = components[3]
            let recordKey = components[5]
            let collection: String

            switch components[4] {
                case "post":
                    collection = "app.bsky.feed.post"
                case "lists":
                    collection = "app.bsky.graph.list"
                case "feed":
                    collection = "app.bsky.feed.generator"
                default:
                    throw ATRequestPrepareError.invalidFormat
            }

            return RecordQuery(repository: record, collection: collection, recordKey: recordKey)
        } else {
            throw ATRequestPrepareError.invalidFormat
        }
    }

    /// Checks if the string matches the given regular expression pattern.
    ///
    /// This method uses either `Regex` or `NSRegularExpression` to determine if the
    /// entire string matches the specified regular expression pattern.
    ///
    /// - Parameters:
    ///   - pattern: The regular expression pattern to match against.
    ///   - text: The string used for the match.
    /// - Returns: A `[String]` that displays all of the matches in `text`, or `nil`
    /// if there are no matches.
    public static func match(_ pattern: String, in text: String) -> [String?]? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: text.utf16.count)
            guard let match = regex.firstMatch(in: text, options: [], range: range) else {
                return nil
            }

            print(match.numberOfRanges)

            var results: [String?] = []
            for i in 0..<match.numberOfRanges {
                let range = match.range(at: i)
                if range.location != NSNotFound, let range = Range(range, in: text) {
                    results.append(String(text[range]))
                } else {
                    results.append(nil)
                }
            }
            return results
        } catch {
            return nil
        }
    }

    /// Generates a random alphanumeric string with a specified length
    ///
    /// A maximum of 25 characters can be created for the string. This is useful for generating
    /// random file names when uploading blobs into the server.
    ///
    /// - Parameter length: The number of characters the string will generate. Defaults to `8`.
    /// - Returns: a string with each character being a random character, repeated to the
    /// specified length.
    public func generateRandomString(length: Int = 8) -> String {
        let maxAllowedLength = 25
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        // Ensure that the requested length does not exceed the maximum allowed limit
        let finalLength = min(length, maxAllowedLength)

        return String((0..<finalLength).compactMap { _ in characters.randomElement() })
    }

    /// A structure for a record.
    public struct RecordQuery: Codable {

        /// The handle or decentralized identifier (DID) of the repo."
        ///
        /// - Note: According to the AT Protocol specifications: "The handle or DID of the repo."
        public let repository: String

        /// The NSID of the record.
        ///
        /// - Note: According to the AT Protocol specifications: "The NSID of the record collection."
        public let collection: String

        /// The record's key.
        ///
        //// - Note: According to the AT Protocol specifications: "The Record Key."
        public let recordKey: String

        /// The CID of the version of the record. Optional. Defaults to `nil`.
        ///
        /// - Note: According to the AT Protocol specifications: "The CID of the version of the record.
        /// If not specified, then return the most recent version."
        public let recordCID: String? = nil

        public init(repository: String, collection: String, recordKey: String) {
            self.repository = repository
            self.collection = collection
            self.recordKey = recordKey
        }

        enum CodingKeys: String, CodingKey {
            case repository = "repo"
            case collection = "collection"
            case recordKey = "rkey"
            case recordCID = "cid"
        }
    }
}
