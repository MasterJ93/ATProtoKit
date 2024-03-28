//
//  ATDataStreamConfiguration.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation

extension ATEventStreamConfiguration {
    /// Connects the client to the event stream.
    ///
    /// Normally, when connecting to the event stream, it will start from the first message the event stream gets. The client will always look at the last successful
    /// `sequencePosition` and stores it internally. However, the following can occur when `cursor` is invloved:
    /// - If `cursor` is higher than `sequencePosition`, the connection will close after outputting an error.
    /// - If `cursor`is within the server's rollback window, the server will attempt to give the client all of the messages it might have missed.
    /// - If `cursor` is outside of the rollback window, then the server will send an info message saying it's too old, then sends the oldest message it has and
    /// continues the stream.
    /// - If `cursor` is `0`, then the server will send the oldest message it has and continues the stream.
    ///
    /// - Parameter cursor: The mark used to indicate the starting point for the next set of results. Optional.
    public func connect(cursor: Int64?) {

    }

    /// Disconnects the client from the event stream.
    public func disconnect() {

    }

    /// Attempts to reconnect the client to the event stream after a disconnect.
    ///
    /// This method can only be used if the client didn't disconnect itself from the server.
    public func reconnect(cursor: Int64?) {

    }

    public func receiveMessages() {

    }

    /// Pings the server to maintain a connection.
    public func ping() {
        
    }
}
