import XCTest
@testable import ATProtoKit

final class LabelsUnionTests: XCTestCase {
    
    func testLabelsUnionEncodingIncludesType() throws {
        // Create a SelfLabelsDefinition
        let selfLabel = ComAtprotoLexicon.Label.SelfLabelDefinition(value: "adult")
        let selfLabels = ComAtprotoLexicon.Label.SelfLabelsDefinition(values: [selfLabel])
        
        // Create LabelsUnion
        let labelsUnion = AppBskyLexicon.Graph.ListRecord.LabelsUnion.selfLabels(selfLabels)
        
        // Encode to JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder.encode(labelsUnion)
        let jsonString = String(data: data, encoding: .utf8)!
        
        print("Encoded LabelsUnion:")
        print(jsonString)
        
        // Verify $type is present
        XCTAssertTrue(jsonString.contains("\"$type\""), "JSON should contain $type field")
        XCTAssertTrue(jsonString.contains("\"com.atproto.label.defs#selfLabels\""), "JSON should contain correct $type value")
        
        // Parse JSON to verify structure
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        XCTAssertEqual(json["$type"] as? String, "com.atproto.label.defs#selfLabels")
        XCTAssertNotNil(json["values"], "JSON should contain values array")
    }
}