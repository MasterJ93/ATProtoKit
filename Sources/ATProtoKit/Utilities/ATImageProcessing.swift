//
//  ATImageProcessing.swift
//
//
//  Created by Christopher Jr Riley on 2024-02-08.
//

import Foundation

#if canImport(UIKit)
import UIKit
/// A type for `UIImage` on platforms where `UIKit` is available (iOS, iPadOS, tvOS, watchOS, visionOS, Mac Catalyst).
///
/// `ATImage` is a type alias that gives a unified way of handling images for preparation for uploading to the AT Protocol. This allows the abstraction of both `UIImage` and `NSImage`, giving
/// `ATImageProcessable` more breathing room for implementation.
public typealias ATImage = UIImage
#elseif canImport(AppKit)
import AppKit
import ImageIO
/// A type for `NSImage` on platforms where `AppKit` is available (macOS).
///
/// `ATImage` is a type alias that gives a unified way of handling images for preparation for uploading to the AT Protocol. This allows the abstraction of both `UIImage` and `NSImage`, giving
/// `ATImageProcessable` more breathing room for implementation.
public typealias ATImage = NSImage
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
/// Implementing `ATImageProcessable` allows for the customization of image processing tasks, making it useful for developers working on platforms where standard image objects like
/// `UIImage` or `NSImage` are not available, such as in Linux environments.
///
/// ### Methods
///   - `convertToImageQuery(image:altText:targetFileSize)`: Converts an image object into an `ImageQuery` instance. This instance encapsulates the image data along with metadata such as
/// the file name and alternative text, preparing it for upload. It also attempts to shrink the file size down to an approprate amount.
///   - `stripMetadata(from:)`: Removes EXIF and GPS metadata from the provided image data. This is crucial for protecting privacy and reducing the size of the image data being transmitted.
/// - Important: `stripMetadata(from:)` is an important method to create as, according to the AT Protocol documentation, the protocol may be more strict about stripping metadata in the future.\
/// \
/// Also, this should be an `internal` method, as it will be part of `convertToImageQuery(image:altText:targetFileSize)`. It's recommended that it's called before
/// ``convertToImageQuery(image:altText:targetFileSize)`` attempts to access the image.
///
/// ### Example
/// Below is a sample implementation showcasing how to conform to `ATImageProcessable` for a custom image type:
/// ```swift
/// class CustomImageProcessor: ATImageProcessable {
///      func convertToImageQuery(imagePath: String, altText: String, targetFileSize: Int = 1_000_000) -> ImageQuery? {
///          let atImage = stripMetadata(from: image)
///          guard let customImage = atImage as? CustomImageType else {
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
///      func stripMetadata(from image: ATImage) -> Data {
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
public protocol ATImageProcessable {
    /// Processes an image to be suitable for the AT Protocol servers.
    ///
    /// It's required for the image to be less than 1MB (1,000,000 bytes). This method will shrink the file size to the largest possible size that doesn't exceed the limit. Note that image quality may be affected.
    /// - Parameters:
    ///   - image: The file path of the image that needs to be prepared.
    ///   - altText: The alt text used to help blind and low-vision users know what's contained in the text. Optional.
    ///   - targetFileSize: The size (in bytes) the file needs to be.
    /// - Returns: An ``ImageQuery``, which combines the image itself in a `Data` format and the alt text.
    func convertToImageQuery(imagePath: String, altText: String?, targetFileSize: Int) -> ImageQuery?
    /// Removes all EXIF and GPS metadata from the image.
    ///
    /// This method should ideally be before ``convertToImageQuery(imagePath:altText:targetFileSize:)-2fma7`` does anything to the image, as it will help with the process of maintaining more of the image quality.
    func stripMetadata(from image: ATImage) -> ATImage?
}

public extension ATImageProcessable {
    public func convertToImageQuery(imagePath: String, altText: String?, targetFileSize: Int = 1_000_000) -> ImageQuery? {
        guard let image = NSImage(contentsOfFile: imagePath) else {
            print("Image could not be loaded.")
            return nil
        }

        guard let atImage = stripMetadata(from: image),
              let tiffData = atImage.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData) else {
            return nil
        }

        // Aspect ratio.
        let imageHeight = atImage.size.height
        let imageWidth = atImage.size.width

        // Calculate the aspect ratio. Make sure it's not dividing by zero.
        let aspectRatio: CGFloat = imageHeight > 0 ? imageWidth / imageHeight : 0

        // Determine the image format from the file extension.
        let filename = URL(fileURLWithPath: imagePath).lastPathComponent

        let fileExtension = (imagePath as NSString).pathExtension.lowercased()
        var imageData: Data? = nil

        switch fileExtension {
            case "png":
                imageData = bitmapImage.representation(using: .png, properties: [:])
            case "jpg", "jpeg":
                do {
                    imageData = try decreaseJPGSize(tiffData, bitmapImage: bitmapImage, targetFileSize: targetFileSize)
                } catch ATImageProcessingError.unableToResizeImage {
                    return nil
                } catch {
                    // Handle any other errors
                    print("An unexpected error occurred: \(error.localizedDescription)")
                    return nil
                }
            case "gif":
                imageData = bitmapImage.representation(using: .gif, properties: [:])
            case "webp":
                imageData = bitmapImage.representation(using: .tiff, properties: [:])
            default:
                print("Unsupported file format: \(fileExtension).")
                return nil
        }

        if let imageData {
            return ImageQuery(imageData: imageData, fileName: filename, altText: altText)
        }

        return nil
    }

    internal func decreaseJPGSize(_ image: Data, bitmapImage: NSBitmapImageRep, targetFileSize: Int) throws -> Data {
        var imageData = image
        var imageBitmap = bitmapImage
        // Check if the file size is already lower than the targetFileSize.
        if imageData.count <= targetFileSize {
            return image
        }

        // Loops while the size of the image exceeds the target image size.
        var compressionFloat = 1.0

        while compressionFloat >= 0.5 {
            var imageInstance = bitmapImage

            // Lower the compression factor by 5%.
            compressionFloat -= 0.05

            guard let finalImage = imageInstance.representation(using: .jpeg, properties: [.compressionFactor : compressionFloat]) else {
                break
            }

            // If the resulting compression makes the file size lower, set the value and break the loop.
            if finalImage.count <= targetFileSize {
                imageBitmap = imageInstance
                break
            }
        }

        throw ATImageProcessingError.unableToResizeImage
    }

    func stripMetadata(from image: ATImage) -> ATImage? {
        guard let tiffRepresentation = image.tiffRepresentation,
              let source = CGImageSourceCreateWithData(tiffRepresentation as CFData, nil) else {
            return nil
        }

        let mutableData = NSMutableData()
        guard let type = CGImageSourceGetType(source),
              let destination = CGImageDestinationCreateWithData(mutableData, type, 1, nil) else {
            return nil
        }

        let removeExifProperties: [String: Any] = [
            kCGImagePropertyExifDictionary as String: NSNull(),
            kCGImagePropertyGPSDictionary as String: NSNull()
        ]

        CGImageDestinationAddImageFromSource(destination, source, 0, removeExifProperties as CFDictionary)
        if !CGImageDestinationFinalize(destination) {
            print("CGImageDestinationFinalize failed")
            return nil
        }

        return ATImage(data: mutableData as Data)
    }
}
