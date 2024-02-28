//
//  ATImageProcessing.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

protocol ImageProtocol {
    func toData() -> Data?
    static func stripEXIF(from data: Data) -> Data?
    func loadImageData(from imagePath: String) -> Self?
}


/// Provides a standardized approach to processing images for uploading to servers that interact with the AT Protocol.
///
/// This protocol aids in the conversion of images into an ``ImageQuery`` (which is used to give all of the necessary information
/// about the image for the server), while ensuring that privacy-sensitive EXIF data is stripped from the images before upload.
///
/// Implementing `ATImageProcessable` allows for the customization of image processing tasks, making it useful for developers working on platforms where standard image objects like `UIImage` or `NSImage` are not available, such as in Linux environments.
///
/// ### Methods
///   - `convertToImageQuery(image:, altText:)`: Converts an image object into an `ImageQuery` instance. This instance encapsulates the image data along with metadata such as the file name and alternative text, preparing it for upload.
///   - `stripEXIFData(from:)`: Removes EXIF metadata from the provided image data. This is crucial for protecting privacy and reducing the size of the image data being transmitted. Please note that this is an important method to create as, according to the AT Protocol documentation, the protocol may be more strict about stripping metadata in the future.
/// - Important: `stripEXIFData(from data: Data)` is an important method to create as, according to the AT Protocol documentation, the protocol may be more strict about stripping metadata in the future.
///
/// ### Example
/// Below is a sample implementation showcasing how to conform to `ATImageProcessable` for a custom image type:
/// ```swift
/// class CustomImageProcessor: ATImageProcessable {
///      func convertToImageQuery(image: AnyObject, altText: String) -> ImageQuery? {
///          guard let customImage = image as? CustomImageType else {
///              return nil
///          }
///          let imageData = customImage.convertToData() // Your method to convert the image to Data
///          let fileName = "customImage.jpg" // Determine an appropriate file name
///
///          // Strip EXIF data if necessary
///          let cleanImageData = stripEXIFData(from: imageData)
///
///          return ImageQuery(imageData: cleanImageData, fileName: fileName, altText: altText)
///      }
///
///      func stripEXIFData(from data: Data) -> Data {
///          // Implementation to remove EXIF data from the image data.
///          return data
///      }
/// }
///
/// ```
///
/// ### Usage
/// After implementing `ATImageProcessable`, you can use your custom image processor to prepare images for upload in a way
/// that aligns with your application's requirements:
/// ```swift
/// Task {
///     let customImageProcessor = CustomImageProcessor()
///     let image1 = customImageProcessor.convertToData("path/to/image/cat.jpg", withAltText: "A cat, looking directly at the camera.").stripEXIFData()
///     let imageQueries = [image1]
///
///     await atProto.createPostRecord(text: "Look at my cute cat!", embed: .images(images: imageQueries))
/// }
/// ```
public protocol ImageProcessable {
    func convertToImageQuery(image: AnyObject, altText: String) -> ImageQuery?
    func stripEXIFData(from data: Data) -> Data
}
