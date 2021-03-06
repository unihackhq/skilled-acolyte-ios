//
//  Team.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct Team: Codable, Equatable {
    
    var id: String = ""
    var eventId: String = ""
    var name: String = ""
    var shortDescription: String = ""
    var longDescription: String?
    var devpostLink: String?
    var photoUrl: String?
    var members: [Student] = [Student]()
    var pendingInvitations: [Student] = [Student]()
    
    init() {}
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        id = data["id"] as! String
        eventId = data["eventId"] as! String
        name = data["name"] as! String
        shortDescription = data["shortDescription"] as! String
        longDescription = data["longDescription"] as? String
        devpostLink = data["devpostLink"] as? String
        photoUrl = data["photoUrl"] as? String
        if let membersData = data["members"] as? [[String:Any]] {
            for memberData in membersData {
                let member = Student(data: memberData)
                members.append(member)
            }
        }
        if let invitations = data["invited"] as? [[String:Any]] {
            for inviteData in invitations {
                let invite = Student(data: inviteData)
                pendingInvitations.append(invite)
            }
        }
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if id != "" { json["id"] = id }
        if eventId != "" { json["eventId"] = eventId }
        if name != "" { json["name"] = name }
        if shortDescription != "" { json["shortDescription"] = shortDescription }
        
        if let longDescription = longDescription { json["longDescription"] = longDescription }
        if let devpostLink = devpostLink { json["devpostLink"] = devpostLink }
        if let photoUrl = photoUrl { json["photoUrl"] = photoUrl }
        
        return json
    }
    
    static func == (left: Team, right: Team) -> Bool {
        return left.id == right.id
    }
}
