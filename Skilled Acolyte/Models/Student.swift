//
//  Student.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

class Student: NSObject {
    
    var firstLaunch: Bool!
    var id: String!
    var universityId: String!
    var user: User!
    var studyLevel: String?
    var degree: String?
    var dietaryReq: String?
    var medicalReq: String?
    var shirtSize: String?
    var photoUrl: String?
    var tickets: [Ticket]! = [Ticket]()
    
    init(data: [String:Any]) {
        
        // Initalizers
        firstLaunch = data["firstLaunch"] as! Bool
        id = data["id"] as! String
        universityId = data["universityId"] as! String
        
        // Personal data
        user = User(data: data["user"] as! [String:Any])
        
        // Optional things
        studyLevel = data["studyLevel"] as? String
        degree = data["degree"] as? String
        dietaryReq = data["dietaryReq"] as? String
        medicalReq = data["medicalReq"] as? String
        shirtSize = data["shirtSize"] as? String
        photoUrl = data["photoUrl"] as? String
        for ticket in data["Tickets"] as! [[String:Any]] {
            tickets.append(Ticket(data: ticket))
        }
    }
}
