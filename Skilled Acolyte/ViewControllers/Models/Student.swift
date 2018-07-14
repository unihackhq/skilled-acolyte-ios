//
//  Student.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

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
    
    func shortName() -> String! {
        if let preferred = user.preferredName {
            return preferred
        } else if let first = user.firstName {
            return first
        }
        return ""
    }
    
    func fullName() -> String! {
        let first = (user.firstName != nil) ? (user.firstName!+" ") : ""
        let last = user.lastName ?? ""
        return first + last
    }
    
    func initials() -> String! {
        
        let firstName = user.firstName ?? ""
        let lastName = user.lastName ?? ""
        let initials = String(describing:firstName.first!) + String(describing:lastName.first!)
        if initials != "" {
            return initials
        }
        
        if let prefName = user.preferredName {
            return String(describing:prefName.first!)
        }
        
        return ""
    }
    
    func downloadPhoto() -> UIImage? {
        // Try to load in an image
        if let imgUrl = photoUrl {
            guard let data = try? Data(contentsOf: URL(string:imgUrl)!) else { return nil }
            return UIImage(data: data)
        } else {
            return nil
        }
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
