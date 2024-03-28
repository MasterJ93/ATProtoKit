//
//  ATFirehoseStreamModels.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

/// A protocol used for the basic skeleton of the model definitions.
public protocol FirehoseEventRepresentable: Decodable {
    /// Represents the stream sequence number of this message.
    ///
    /// - Note: According to the AT Protocol specifications: "The stream sequence number of this message."
    var sequence: Int? { get }
    // TODO: Remove this.
    /// The date and time the object was sent to the stream.
    ///
    /// - Note: According to the AT Protocol specifications: "Timestamp of when this message was originally broadcast."
    var timeStamp: Date { get }
}
