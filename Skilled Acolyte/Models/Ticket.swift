//
//  Ticket.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct Ticket {
    
    var id: String = ""
    var eventbriteOrder: String = ""
    var ticketType: String = ""
    var transferred: Bool! = false
    var cancelled: Bool! = false
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        id = data["id"] as! String
        eventbriteOrder = data["eventbriteOrder"] as! String
        ticketType = data["ticketType"] as! String
        if let transferred = data["transferred"] as? Bool { self.transferred = transferred }
        if let cancelled = data["cancelled"] as? Bool { self.cancelled = cancelled }
            
    }
}
