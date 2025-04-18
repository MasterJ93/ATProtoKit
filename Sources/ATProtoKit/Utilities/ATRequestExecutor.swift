//
//  ATRequestExecutor.swift
//  ATProtoKit
//
//  Created by Christopher Jr Riley on 2025-04-18.
//

import Foundation

///
public protocol ATRequestExecutor {

    ///
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse)
}
