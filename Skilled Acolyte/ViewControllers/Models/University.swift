//
//  University.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct University: Codable, Equatable {
    
    var id: String = ""
    var name: String?
    var country: String = ""
    
    init(data: [String:Any]?) {
        guard let data = data else { return }
        
        id = data["id"] as! String
        name = data["name"] as? String
        country = data["country"] as! String
    }
    
    func toJSON() -> [String:Any] {
        
        var json = [String:Any]()
        
        if id != "" { json["id"] = id }
        if name != "" { json["name"] = name }
        if country != "" { json["country"] = country }
        
        return json
    }
    
    static func == (left: University, right: University) -> Bool {
        return left.id == right.id
    }
}
