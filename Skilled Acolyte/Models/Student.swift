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
    var id: String!
    var universityId: String?
    var user: User!
    var studyLevel: String?
    var degree: String?
    var dietaryReq: String?
    var medicalReq: String?
    var shirtSize: String?
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
        dietaryReq = data["dietaryReq"] as? String
        medicalReq = data["medicalReq"] as? String
        shirtSize = data["shirtSize"] as? String
        photoUrl = data["photoUrl"] as? String
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if let firstLaunch = firstLaunch { json["firstLaunch"] = firstLaunch }
        if let id = id { json["id"] = id }
        if let universityId = universityId { json["universityId"] = universityId }
        if let user = user { json["user"] = user.toJSON() }
        if let studyLevel = studyLevel { json["studyLevel"] = studyLevel }
        if let degree = degree { json["degree"] = degree }
        if let dietaryReq = dietaryReq { json["dietaryReq"] = dietaryReq }
        if let medicalReq = medicalReq { json["medicalReq"] = medicalReq }
        if let shirtSize = shirtSize { json["shirtSize"] = shirtSize }
        if let photoUrl = photoUrl { json["photoUrl"] = photoUrl }
        
        return json
    }

}
