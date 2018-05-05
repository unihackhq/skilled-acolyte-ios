//
//  User.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var id: String!
    var firstName: String!
    var lastName: String!
    var preferredName: String!
    var email: String!
    var dateOfBirth: Date!
    var gender: String!
    var mobile: String!
    // var deactivated: Bool!
    
    init(data: [String:Any]) {
        id = data["id"] as! String
        firstName = data["firstName"] as! String
        lastName = data["lastName"] as! String
        preferredName = data["preferredName"] as! String
        email = data["email"] as! String
        dateOfBirth = data["dateOfBirth"] as! Date
        gender = data["gender"] as! String
        mobile = data["mobile"] as! String
    }
}
