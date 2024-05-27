//
//  ATDataStreamConfigurationExtension.swift
//
//
//  Created by Christopher Jr Riley on 2024-03-17.
//

import Foundation
import SwiftCBOR
import Logging

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
    public func connect(cursor: Int64? = nil) async {
        logger.trace("In connect()")
        self.isConnected = true
        self.webSocketTask.resume()
        logger.debug("WebSocketTask resumed.", metadata: ["isConnected": "\(self.isConnected)"])

        await self.receiveMessages()
        logger.trace("Exiting connect()")
    }

    /// Disconnects the client from the event stream.
    /// 
    /// - Parameters:
    ///   - closeCode: A code that indicates why the event stream connection closed.
    ///   - reason: The reason why the client disconnected from the server.
    public func disconnect(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data) {
        logger.trace("In disconnect()")
        logger.debug("Closing websocket", metadata: ["closeCode": "\(closeCode)", "reason": "\(reason)"])
        webSocketTask.cancel(with: closeCode, reason: reason)
        logger.trace("Exiting disconnect()")
    }

    /// Attempts to reconnect the client to the event stream after a disconnect.
    ///
    /// This method can only be used if the client didn't disconnect itself from the server.
    ///
    /// - Parameters:
    ///   - cursor: The mark used to indicate the starting point for the next set of results. Optional.
    ///   - retry: The number of times the connection attempts can be retried.
    func reconnect(cursor: Int64?, retry: Int) async {
        logger.trace("In reconnect()")
        guard isConnected == false else {
            logger.debug("Already connected. No need to reconnect.")
            return
        }
        
        let lastCursor: Int64 = sequencePosition ?? 0
        
        if lastCursor > 0 {
            logger.debug("Fetching missed messages", metadata: ["lastCursor": "\(lastCursor)"])
            await fetchMissedMessages(fromSequence: lastCursor)
        }
        logger.trace("Exiting reconnect()")
    }

    /// Receives decoded messages and manages the sequence number.
    ///
    /// This will attempt to decode each of the messages that arrive from the event stream. All of the messages are in a [DAG-CBOR][DAG_CBOR] format and are decoded accordingly.
    ///
    /// [DAG_CBOR]: https://ipld.io/docs/codecs/known/dag-cbor/
    public func receiveMessages() async {
        logger.trace("In receiveMessages()")
        while isConnected {
            do {
                let message = try await webSocketTask.receive()
                
                switch message {
                    case .string(let base64String):
                        logger.debug("Received a string message", metadata: ["length": "\(base64String.count)"])
                        ATCBORManager().decodeCBOR(from: base64String)
                    case .data(let data):
                        logger.debug("Received a data message", metadata: ["length": "\(data.count)"])
                        let base64String = data.base64EncodedString()
                        ATCBORManager().decodeCBOR(from: base64String)
                    @unknown default:
                        logger.warning("Received an unknown type of message.")
                }
            } catch {
                logger.error("Error while receiving message.", metadata: ["error": "\(error)"])
            }
        }
        logger.trace("Exiting receiveMessages()")
    }
    
    public func fetchMissedMessages(fromSequence lastCursor: Int64) async {
        logger.trace("In fetchMissedMessages()")
        
        logger.trace("Exiting fetchMissedMessages()")
    }
}
