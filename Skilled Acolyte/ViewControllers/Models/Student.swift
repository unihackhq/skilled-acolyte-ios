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
    var photoUrl: String? {
        didSet {
            UserDefaults.standard.removeObject(forKey: id+"-photo")
        }
    }
    
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
        let first = (user.firstName != nil) ? (user.firstName!+" ") : (user.preferredName != nil ? user.preferredName!+" " : "")
        let last = user.lastName ?? ""
        return first + last
    }
    
    func initials() -> String! {
        
        // Safely and optionally extract the first char of the first/last name
        var initials = ""
        if let firstName = user.firstName,
            let first = firstName.first {
            initials += String(describing:first)
        } else if let prefName = user.preferredName,
            let prefInitial = prefName.first {
            initials += String(describing:prefInitial)
        }
        if let lastName = user.lastName,
            let last = lastName.first {
            initials += String(describing:last)
        }
        
        return initials
    }
    
    @discardableResult func downloadPhoto() -> UIImage? {
        
        // Look for a cached image
        if let cachedImageData = UserDefaults.standard.object(forKey: id+"-photo") as? Data {
            return UIImage(data: cachedImageData)
        }

        // Otherwise try to load in an image
        if let imgUrl = photoUrl {
            guard let data = try? Data(contentsOf: URL(string:imgUrl)!) else { return nil }
            guard let image = UIImage(data: data) else { return nil }
            UserDefaults.standard.set(data, forKey: id+"-photo")
            return image
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
