//
//  Event.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 25/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    var id: String = ""
    var name: String = ""
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        // Initalizers
        id = data["id"] as! String
        name = data["name"] as! String
    }
}
