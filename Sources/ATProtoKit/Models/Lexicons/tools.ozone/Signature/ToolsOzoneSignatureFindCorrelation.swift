//
//  ToolsOzoneSignatureFindCorrelation.swift
//
//
//  Created by Christopher Jr Riley on 2024-10-24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ToolsOzoneLexicon.Signature {

    /// An output model for searching all threat signatures between at least two user accounts.
    ///
    /// - Note: According to the AT Protocol specifications: "Find all correlated threat
    /// signatures between 2 or more accounts."
    ///
    /// - SeeAlso: This is based on the [`tools.ozone.signature.findCorrelation`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/tools/ozone/signature/findCorrelation.json
    public struct FindCorrelationOutput: Sendable, Codable {

        /// An array of details for each signature.
        public let details: [ToolsOzoneLexicon.Signature.SignatureDetailDefinition]
    }
}
