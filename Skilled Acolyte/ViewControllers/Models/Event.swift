//
//  Event.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 25/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

struct Event: Codable {
    
    var id: String = ""
    var name: String = ""
    var location: String?
    var logoUrl: String?
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        // Initalizers
        id = data["id"] as! String
        name = data["name"] as! String
        
        // Optional things
        location = data["location"] as? String
        logoUrl = data["logoUrl"] as? String
    }
    
    func downloadPhoto() -> UIImage? {
        // Try to load in an image
        if let imgUrl = logoUrl {
            guard let data = try? Data(contentsOf: URL(string:imgUrl)!) else { return nil }
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
