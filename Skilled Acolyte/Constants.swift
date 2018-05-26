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
            if let student = student {
                do {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(student), forKey: "currentStudent")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "currentStudent")
            }
        }
        get {
            if let decodedData = UserDefaults.standard.value(forKey: "currentStudent") as? Data {
                do {
                    return try? PropertyListDecoder().decode(Student.self, from: decodedData)
                }
            }
            return nil
        }
    }
}
