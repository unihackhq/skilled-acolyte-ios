//
//  Event.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 25/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

class Event: NSObject {
    
    var id: String!
    var name: String!
    
    init(data: [String:Any]) {
        
        // Initalizers
        id = data["id"] as! String
        name = data["name"] as! String
    }
}
