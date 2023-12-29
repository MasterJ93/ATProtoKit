import Foundation

func loginToBluesky(with blueskyHandle: String, and appPassword: String, pdsURL: String = "https://bsky.social",
                    completion: @escaping (Result<[String: Any], Error>) -> Void) {
    guard let url = URL(string: "\(pdsURL)/xrpc/com.atproto.server.createSession") else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let credentials = ["identifier": blueskyHandle, "password": appPassword]
    guard let httpBody = try? JSONSerialization.data(withJSONObject: credentials) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Error encoding credentials"])))
        return
    }
    
    request.httpBody = httpBody
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
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
