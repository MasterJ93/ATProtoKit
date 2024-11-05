//
//  ATProtoBluesky.swift
//
//
//  Created by Christopher Jr Riley on 2024-11-04.
//

import Foundation

extension ATProtoBluesky {

    /// A protocol used to easily access the metadata for a website.
    ///
    /// To use this protocol, attach it to a `struct` of your creation, then implement
    /// ``ATProtoBluesky/ExternalLinkMetadata/grabMetadata`` based on whatever method you would
    /// use to access the title.
    ///
    /// The `url` property would simply be the link captured from the `link` arguement, so you can
    /// simply pass through that argument as the `url` property.
    ///
    /// The `description` property is an optional property since some websites may not contain one.
    /// It's recommended that you either add some text saying not description is provided, or by
    /// some other means (e.g.: the beginning of an article in the webpage).
    public protocol ExternalLinkMetadata: Sendable {

        /// The URL of the external link.
        var url: URL { get }

        /// The title of the external link. Optional.
        var title: String? { get }

        /// The description of the external link. Optional.
        var description: String? { get }

        /// The URL of the thumbnail image. Optional.
        var thumbnailURL: URL? { get }

        
        /// Fills the properties of the `struct` conforming
        ///
        /// - Parameter link: The URL to get the metadata.
        ///
        /// - Throws: The URL doesn't exist or the URL doesn't contain sufficient
        /// enough information.
        func grabMetadata(from link: URL) async throws
    }
}
