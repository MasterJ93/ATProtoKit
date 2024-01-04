import Foundation

var currentSession: Result<[String: Any], Error>?

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

func createPost(text: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    //    guard let session = currentSession else {
    //        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Session not initialized"])))
    //        return
    //    }
    
    var accessJwt: String
    var did: String
    
    switch currentSession {
        case .success(let session):
            accessJwt = session["accessJwt"] as! String
            did = session["did"] as! String
            print("SUCCESS")
        case .failure(let error):
            accessJwt = ""
            did = ""
            print("WE HAVE AN ERROR.")
            break;
        case .none:
            accessJwt = ""
            did = ""
            print("WHY IS IT THIS ONE?")
            break;
    }
    
    let now = ISO8601DateFormatter().string(from: Date())
    
    let post: [String: Any] = [
        "$type": "app.bsky.feed.post",
        "text": text,
        "createdAt": now
    ]
    
    guard let url = URL(string: "https://bsky.social/xrpc/com.atproto.repo.createRecord") else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(accessJwt)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody: [String: Any] = [
        "repo": did,
        "collection": "app.bsky.feed.post",
        "record": post
    ]
    
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
