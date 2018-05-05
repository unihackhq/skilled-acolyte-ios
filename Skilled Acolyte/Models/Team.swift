//
//  Team.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

class Team: NSObject {
    
    var id: String!
    var name: String!
    var teamDescription: String!
    var photoUrl: String!
    
    init(data: [String:Any]) {
        id = data["id"] as! String
        name = data["name"] as! String
        teamDescription = data["teamDescription"] as! String
        photoUrl = data["photoUrl"] as! String
    }
}
