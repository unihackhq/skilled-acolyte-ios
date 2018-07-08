//
//  Student.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct Student: Codable {
    
    var firstLaunch: Bool?
    var id: String = ""
    var universityId: String?
    var user: User = User(data: nil)
    var studyLevel: String?
    var degree: String?
    var photoUrl: String?
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        // Initalizers
        firstLaunch = data["firstLaunch"] as? Bool
        id = data["id"] as! String
        universityId = data["universityId"] as? String
        
        // Personal data
        user = User(data: data["user"] as? [String:Any])
        
        // Optional things
        studyLevel = data["studyLevel"] as? String
        degree = data["degree"] as? String
        photoUrl = data["photoUrl"] as? String
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if id != "" { json["id"] = id }
        json["user"] = user.toJSON()
        
        if let universityId = universityId { json["universityId"] = universityId }
        if let studyLevel = studyLevel { json["studyLevel"] = studyLevel }
        if let degree = degree { json["degree"] = degree }
        if let photoUrl = photoUrl { json["photoUrl"] = photoUrl }
        
        return json
    }

}
