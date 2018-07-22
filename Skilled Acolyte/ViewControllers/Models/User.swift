//
//  User.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var id: String = ""
    var firstName: String?
    var lastName: String?
    var preferredName: String?
    var email: String?
    var dateOfBirth: Date?
    var gender: String?
    var mobile: String?
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        id = data["id"] as! String
        firstName = data["firstName"] as? String
        lastName = data["lastName"] as? String
        preferredName = data["preferredName"] as? String
        email = data["email"] as? String
        if let dob = data["dateOfBirth"] as? String {
            dateOfBirth = Tools().date(fromIso: dob)
        }
        gender = data["gender"] as? String
        mobile = data["mobile"] as? String
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if id != "" { json["id"] = id }
        
        if let firstName = firstName { json["firstName"] = firstName }
        if let lastName = lastName { json["lastName"] = lastName }
        if let preferredName = preferredName { json["preferredName"] = preferredName }
        if let email = email { json["email"] = email }
        if let dateOfBirth = dateOfBirth { json["dateOfBirth"] = Tools().iso(fromDate: dateOfBirth) } // TODO: convert back to string
        if let gender = gender { json["gender"] = gender }
        if let mobile = mobile { json["mobile"] = mobile }
        
        return json
    }
    
}
