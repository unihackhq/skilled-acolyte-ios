//
//  Networking.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 20/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

class Networking: NSObject {
    
    let session: URLSession!
    
    override init() {
        // We must initlize non-nil variables before super.init()
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        
        super.init()
    }
    
    func request(with httpMethod:String!, url:String!, body:[String:Any]?, completion:((Error?, [String:Any]?) -> Void)?) {
        
        // Build a http request
        let request = NSMutableURLRequest(url: URL(string: url)!)
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
}
