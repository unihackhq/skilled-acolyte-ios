//
//  Constants.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct Constants {
    
    static let HOST_URL = "http://localhost:3000/api/v1"
    static var CurrentStudent: Student? {
        set(student) {
            UserDefaults.standard.set(student, forKey: "currentStudent")
        }
        get {
            return UserDefaults.standard.object(forKey: "currentStudent") as? Student
        }
    }
}
