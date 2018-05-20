//
//  Networking.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 20/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation


class Networking: NSObject {
    
    struct Methods {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
    }
    
    let session: URLSession! = URLSession(configuration: URLSessionConfiguration.default)
    let baseURL: String! = "http://localhost:3000"
    
    
    func login(email: String!, completion:((Error?, [String:Any]?) -> Void)?) {
        
        // TODO: use the email
        request(method: Methods.POST, url: "/token", body: nil) { (error, response) in
            // do something important :)
            // handle error if any
        }
    }
    
    // MARK: HTTP request making methods
    
    func request(method httpMethod:String!, url:String!, body:[String:Any]?, completion:((Error?, [String:Any]?) -> Void)?) {
        
        // Build a http request
        
        let request = NSMutableURLRequest()
        request.url = buildURL(with: url)
        request.httpMethod = httpMethod
        // Encode the body as json (if it exists)
        if let body = body {
            do {
                let jsonEncode = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                request.httpBody = jsonEncode
            } catch {
                print("Failed to encode json: \(error.localizedDescription)")
            }
        }

        // Make the request (.resume() to start the request)
        session.dataTask(with: request as URLRequest) { (data, response, error) in

            // Unpack data response if it exisits
            var jsonDecode:[String:Any]?
            if let data = data {
                do {
                    jsonDecode = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String : Any]
                } catch {
                    print("Failed to decode json: \(error.localizedDescription)")
                }
            }
            
            // Call completion if it exists
            if let completion = completion {
                completion(error, jsonDecode)
            }
            
        }.resume()
    }
    
    func buildURL(with path:String!) -> URL! {
        return URL(string: baseURL + path)!
    }
}
