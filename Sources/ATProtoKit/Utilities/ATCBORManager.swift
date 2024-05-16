//
//  ATCBORManager.swift
//  
//
//  Created by Christopher Jr Riley on 2024-05-08.
//

import Foundation
import SwiftCBOR

/// A class that handles CBOR-related objects.
public class ATCBORManager {
    
    /// The length of bytes for a CID according to CAR v1.
    private let cidByteLength: Int = 36
    
    /// The buffer size for CBOR-related objects.
    private let bufferSize: Int = 32768
    
    /// Creates an instance with the needed elements for reading and writing CBOR objects.
    public init() {
        
    }
    
    /// A delegate used to hold a CBOR block.
    public struct CarProgressStatusEvent {
        
        /// The content identifier of the block.
        var cid: String
        
        /// The block of data itself.
        var body: Data
    }
    
    /// Decodes a CBOR string from the event stream.
    ///
    /// - Parameter base64String: The CBOR string to be decoded.
    func decodeCBOR(from base64String: String) {
        guard let data = Data(base64Encoded: base64String) else {
            print("Invalid Base64 string")
            return
        }
        
        do {
            let items = try decodeItems(from: data)
            if let cborBlocks = extractCborBlocks(from: items) {
                print("Decoded CBOR:", cborBlocks)
            }
        } catch {
            print("Failed to decode CBOR: \(error)")
        }
    }
    
    /// Decodes individual items from the CBOR string.
    ///
    /// A CBOR string contains two documents: the header and the body. This method will ensure
    /// that both documents are decoded.
    ///
    /// - Parameter data: The CBOR string to be decoded.
    /// - Returns: An array of `CBOR` objects.
    private func decodeItems(from data: Data) throws -> [CBOR] {
        guard let decoded = try CBOR.decodeMultipleItems(data.bytes, options: CBOROptions(useStringKeys: false, forbidNonStringMapKeys: true)) else {
            throw CBORProcessingError.cannotDecode
        }
        
        return decoded
    }
    
    /// <#Description#>
    ///
    /// - Parameter items: <#items description#>
    /// - Returns: <#description#>
    private func extractCborBlocks(from items: [CBOR]) -> [UInt8]? {
        guard let payload = items.last,
              let cborBlocks = payload["blocks"],
              case .byteString(let array) = cborBlocks else {
            return nil
        }
        return array
    }
    
    /// A delegate that runs when a CBOR object is decoded.
    public typealias OnCarDecoded = (CarProgressStatusEvent) -> Void
    
//    /// Decodes a byte array from a CAR file.
//    /// 
//    /// - Parameters:
//    ///   - bytes: The incoming array of bytes.
//    ///   - progress: A delegate that runs when a CBOR object is decoded. Optional.
//    ///   Defaults to `nil`.
//    public func decodeCar(bytes: [UInt8], progress: OnCarDecoded? = nil) {
//        let bytesLength = bytes.count
//        let header = decodeReader(from: bytes)
//        if header.value <= 0 { return }
//        
//        var start = header.length + header.value
//        
//        while start < bytesLength {
//            let body = decodeReader(from: Array(bytes[start...]))
//            if body.value <= 0 { break }
//            
//            start += body.length
//            let cidBytes = Array(bytes[start..<(start + cidByteLength)])
//            let cid = Cid.read(cidBytes) // Assuming a method to read CID from bytes
//            
//            start += cidByteLength
//            let bs = Array(bytes[start..<(start + body.value - cidByteLength)])
//            start += body.value - cidByteLength
//            
//            progress?(CarProgressStatusEvent(cid: cid, body: Data(bs)))
//        }
//    }
    
    /// Scans a specified number of bytes from data.
    ///
    /// - Parameters:
    ///   - data: The data to scan.
    ///   - length: The number of bytes to scan.
    /// - Returns: A subset of the data if the length is valid.
    /// - Throws: An error if the data length is not sufficient.
    func scanData(data: Data, length: Int) throws -> Data {
        guard data.count >= length else {
            throw ATEventStreamError.insufficientDataLength
        }
        return data.subdata(in: 0..<length)
    }

    /// Decodes data received from a `Data` object into a structured format.
    ///
    /// - Parameter data: The incoming `Data` object.
    /// - Returns: A ``CBORDecodedBlock``, containing the decoded value and the length of
    /// the processed data.
    func decodeWebSocketData(_ data: Data) -> CBORDecodedBlock? {
        var index = 0
        var result = [UInt8]()
        
        while index < data.count {
            let byte = data[index]
            result.append(byte)
            index += 1
            if (byte & 0x80) == 0 {
                break
            }
        }
        
        if result.isEmpty {
            // TODO: Add error handling.
            return nil
        }

        return CBORDecodedBlock(value: decode(result), length: result.count)
    }
    
    /// Decodes a byte array to extract the length and the encoded data.
    ///
    /// - Parameter bytes: The bytes to decode.
    /// - Returns: A ``CBORDecodedBlock`` containing the decoded value and the length of
    /// the processed data.
    public func decodeReader(from bytes: [UInt8]) -> CBORDecodedBlock {
        var index = 0
        var result = [UInt8]()
        
        while index < bytes.count {
            let byte = bytes[index]
            result.append(byte)
            index += 1
            if (byte & 0x80) == 0 {
                break
            }
        }
        
        return CBORDecodedBlock(value: decode(result), length: result.count)
    }
    
    /// Decodes a list of bytes using unsigned LEB128 decoding.
    ///
    /// - Parameter bytes: The bytes to decode.
    /// - Returns: The decoded integer.
    public func decode(_ bytes: [UInt8]) -> Int {
        var result = 0
        for (i, byte) in bytes.enumerated() {
            let element = Int(byte & 0x7F)
            result += element << (i * 7)
        }
        return result
    }
}

/// A structure that holds information about IPLD objects.
public struct CBORDecodedBlock {
    
    /// The decoded integer value.
    public let value: Int
    
    /// The length of bytes that contributed to ``CBORDecodedBlock/value``.
    public let length: Int
}

