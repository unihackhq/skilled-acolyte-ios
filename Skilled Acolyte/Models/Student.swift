//
//  Student.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

class Student: NSObject {
    
    var id: String!
    var universityId: String!
    var studyLevel: String!
    var degree: String!
    var dietaryReq: String!
    var medicalReq: String!
    var shirtSize: String!
    var photoUrl: String!
    
    init(data: [String:Any]) {
        id = data["id"] as! String
        universityId = data["university"] as! String
        studyLevel = data["studyLevel"] as! String
        degree = data["degree"] as! String
        dietaryReq = data["dietaryReq"] as! String
        medicalReq = data["medicalReq"] as! String
        shirtSize = data["shirtSize"] as! String
        photoUrl = data["photoUrl"] as! String
    }
}
