//
//  University.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

class University: NSObject {
    
    var id: String!
    var name: String!
    var country: String!
    
    init(data: [String:Any]) {
        id = data["id"] as! String
        name = data["name"] as! String
        country = data["country"] as! String
    }
}
