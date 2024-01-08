//
//  Post.swift
//
//
//  Created by Christopher Jr Riley on 2024-01-06.
//

import Foundation

extension ATProtoKit {
    public func createPost(text: String, locales: [Locale] = [], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let now = ISO8601DateFormatter().string(from: Date())
        
        var post: [String: Any] = [
            "$type": "app.bsky.feed.post",
            "text": text,
            "createdAt": now
        ]
        
        guard let url = URL(string: "\(session.pdsURL)/xrpc/com.atproto.repo.createRecord") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(session.accessJwt)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var requestBody: [String: Any] = [
            "repo": session.did,
            "collection": "app.bsky.feed.post",
            "record": post
        ]
        
        // Set the languages, if needed.
        if !locales.isEmpty {
            // Put the locale identifiers as a string, then add them as separate items in
            // the `langs` key (which the key-value pair will be added after.
            let localeIdentifiers = locales.map { $0.identifier }
            post["langs"] = localeIdentifiers
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error encoding request body"])))
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String : Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid JSON"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
