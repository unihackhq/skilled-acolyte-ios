//
//  Constants.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct Constants {
    
    static var HOST_URL = "something else"
    static var HOST_URL_DEV = "something else dev"
    static var HOST_URL_LOCAL = "http://localhost:3000/api/v1"
    static var Environment: String! {
        set(env) {
            UserDefaults.standard.set(env, forKey: "environment")
        }
        get {
            if let env = UserDefaults.standard.object(forKey: "environment") as? String {
                return env
            }
            return "prod"
        }
    }
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
