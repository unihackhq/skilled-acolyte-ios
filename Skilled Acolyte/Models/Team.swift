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
    var eventId: String!
    var name: String!
    var teamDescription: String!
    var photoUrl: String!
    
    init(data: [String:Any]) {
        id = data["id"] as! String
        eventId = data["eventId"] as! String
        name = data["name"] as! String
        teamDescription = data["description"] as! String
        photoUrl = data["photoUrl"] as! String
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if let id = id { json["id"] = id }
        if let eventId = eventId { json["eventId"] = eventId }
        if let name = name { json["name"] = name }
        if let teamDescription = teamDescription { json["description"] = teamDescription }
        if let photoUrl = photoUrl { json["photoUrl"] = photoUrl }
        
        return json
    }
}
