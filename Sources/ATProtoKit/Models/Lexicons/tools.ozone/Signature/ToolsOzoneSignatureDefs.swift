//
//  ToolsOzoneSignatureDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Signature {

    /// A definition model for the signature's details.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.signature.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/defs.json
    public struct SignatureDetailDefinition: Sendable, Codable {

        /// The property of the signature details.
        public let property: String

        /// The value of the signature details.
        public let value : String
    }
}
