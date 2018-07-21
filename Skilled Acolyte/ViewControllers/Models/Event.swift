//
//  Event.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 25/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

struct Event: Codable {
    
    var id: String = ""
    var name: String = ""
    var location: String?
//    var startDate: Date?
//    var endDate: Date?
    var logoUrl: String?
//    var logoColour: UIColor?
    var eventInfo: [EventInfoItem] = [EventInfoItem]()
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        // Initalizers
        id = data["id"] as! String
        name = data["name"] as! String
        
        // Optional things
//        startDate = Tools().date(fromIso: data["startDate"] as? String)
//        endDate = Tools().date(fromIso: data["endDate"] as? String)
        location = data["location"] as? String
        logoUrl = data["logoUrl"] as? String
//        logoColour = Tools().uiColor(fromHex: data["logoColour"] as? String)
        eventInfo.append(EventInfoItem(name: "Sponsors", data: data["sponsors"] as? [String:Any]))
        eventInfo.append(EventInfoItem(name: "Prizes", data: data["prizes"] as? [String:Any]))
        eventInfo.append(EventInfoItem(name: "Judges", data: data["judges"] as? [String:Any]))
    }
    
    func downloadPhoto() -> UIImage? {
        // Try to load in an image
        if let imgUrl = logoUrl {
            guard let data = try? Data(contentsOf: URL(string:imgUrl)!) else { return nil }
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if id != "" { json["id"] = id }
        if name != "" { json["name"] = name }
        
        
        if let location = location { json["location"] = location }
        if let logoUrl = logoUrl { json["logoUrl"] = logoUrl }
        
        for item in eventInfo {
            json[item.name] = item.toJSON()
        }
        
        return json
    }
}

struct EventInfoItem: Codable {
    var name: String!
    var summary: String?
    var url: String?
    
    init(name: String, data: [String:Any]?) {
        guard let data = data else { return }
        
        self.name = name
        
        summary = data["summary"] as? String
        url = data["url"] as? String
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if name != "" { json["name"] = name }
        
        if let summary = summary { json["summary"] = summary }
        if let url = url { json["url"] = url }
        
        return json
    }
}
