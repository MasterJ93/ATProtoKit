//
//  ToolsOzoneSignatureDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation

extension ToolsOzoneLexicon.Signature {

    /// A definition model for the signature's details.
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.signature.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/defs.json
    public struct SignatureDetailDefinition: Codable {

        /// The property of the signature details. Optional.
        public let property: String?

        /// The value of the signature details. Optional.
        public let value : String?
    }
}
