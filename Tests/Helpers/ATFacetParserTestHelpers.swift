//
//  ATFacetParserTestHelpers.swift
//  ATProtoKitTests
//
//  Created by Christopher Jr Riley on 2026-08-17.
//

import Foundation

internal struct ByteRange: Equatable {
    internal let byteStart: Int
    internal let byteEnd: Int
}

internal struct LinkExpectation: Equatable {
    internal let text: String
    internal let uri: String
}

internal func expectedByteRanges(
    for matches: [String],
    in text: String
) -> [ByteRange] {
    var ranges = [ByteRange]()
    var searchStart = text.startIndex

    for match in matches {
        guard let range = text.range(of: match, range: searchStart..<text.endIndex) else {
            continue
        }

        let lowerBound = range.lowerBound.samePosition(in: text.utf8) ?? text.utf8.startIndex
        let upperBound = range.upperBound.samePosition(in: text.utf8) ?? text.utf8.startIndex
        let byteStart = text.utf8.distance(from: text.utf8.startIndex, to: lowerBound)
        let byteEnd = text.utf8.distance(from: text.utf8.startIndex, to: upperBound)
        ranges.append(ByteRange(byteStart: byteStart, byteEnd: byteEnd))
        searchStart = range.upperBound
    }

    return ranges
}
