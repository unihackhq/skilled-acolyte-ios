//
//  ScheduleItem.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 18/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct ScheduleItem: Codable {
    
    var id: String = ""
    var name: String = ""
    var scheduleDescription: String?
    var type: String?
    var location: String?
    var startDate: Date?
    var endDate: Date?
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        // Initalizers
        id = data["id"] as! String
        name = data["name"] as! String
        
        // Optional things
        scheduleDescription = data["scheduleDescription"] as? String
        type = data["type"] as? String
        location = data["location"] as? String
        type = data["type"] as? String
        if let startDateStr = data["startDate"] as? String {
            startDate = Tools().date(fromIso: startDateStr)
        }
        if let endDateStr = data["startDate"] as? String {
            endDate = Tools().date(fromIso: endDateStr)
        }
    }
}
