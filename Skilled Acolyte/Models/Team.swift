//
//  Team.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct Team: Codable {
    
    var id: String = ""
    var eventId: String = ""
    var name: String = ""
    var teamDescription: String = ""
    var photoUrl: String?
        
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        id = data["id"] as! String
        eventId = data["eventId"] as! String
        name = data["name"] as! String
        teamDescription = data["description"] as! String
        photoUrl = data["photoUrl"] as? String
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if id != "" { json["id"] = id }
        if eventId != "" { json["eventId"] = eventId }
        if name != "" { json["name"] = name }
        if teamDescription != "" { json["description"] = teamDescription }
        
        if let photoUrl = photoUrl { json["photoUrl"] = photoUrl }
        
        return json
    }
}
