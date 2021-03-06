//
//  Configuration.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 26/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation

struct Configuration {
    
    static var Environment: String! {
        // Options:
        // - local (localhost)
        // - local-wifi (custom ip address)
        // - dev (erfan's host. may be down)
        // - [None] (prod by default)
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
    static var CurrentTicket: Ticket? {
        set(currentTicket) {
            if let currentTicket = currentTicket {
                do {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(currentTicket), forKey: "currentTicket")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "currentTicket")
            }
        }
        get {
            if let decodedData = UserDefaults.standard.value(forKey: "currentTicket") as? Data {
                do {
                    return try? PropertyListDecoder().decode(Ticket.self, from: decodedData)
                }
            }
            return nil
        }
    }
    static var StudentsTickets: [Ticket]? {
        set(studentsTickets) {
            if let studentsTickets = studentsTickets {
                do {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(studentsTickets), forKey: "studentsTickets")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "studentsTickets")
            }
        }
        get {
            if let decodedData = UserDefaults.standard.value(forKey: "studentsTickets") as? Data {
                do {
                    return try? PropertyListDecoder().decode([Ticket].self, from: decodedData)
                }
            }
            return nil
        }
    }
    static var CurrentEvent: Event? {
        set(currentEvent) {
            if let currentEvent = currentEvent {
                do {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(currentEvent), forKey: "currentEvent")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "currentEvent")
            }
        }
        get {
            if let decodedData = UserDefaults.standard.value(forKey: "currentEvent") as? Data {
                do {
                    return try? PropertyListDecoder().decode(Event.self, from: decodedData)
                }
            }
            return nil
        }
    }
    static var StudentsEvents: [Event]? {
        set(studentsEvents) {
            if let studentsEvents = studentsEvents {
                do {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(studentsEvents), forKey: "studentsEvents")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "studentsEvents")
            }
        }
        get {
            if let decodedData = UserDefaults.standard.value(forKey: "studentsEvents") as? Data {
                do {
                    return try? PropertyListDecoder().decode([Event].self, from: decodedData)
                }
            }
            return nil
        }
    }
    static var CurrentTeam: Team? {
        set(currentTeam) {
            if let currentTeam = currentTeam {
                do {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(currentTeam), forKey: "currentTeam")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "currentTeam")
            }
        }
        get {
            if let decodedData = UserDefaults.standard.value(forKey: "currentTeam") as? Data {
                do {
                    return try? PropertyListDecoder().decode(Team.self, from: decodedData)
                }
            }
            return nil
        }
    }
    static var StudentTeams: [Team]? {
        set(studentTeams) {
            if let studentTeams = studentTeams {
                do {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(studentTeams), forKey: "studentTeams")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "studentTeams")
            }
        }
        get {
            if let decodedData = UserDefaults.standard.value(forKey: "studentTeams") as? Data {
                do {
                    return try? PropertyListDecoder().decode([Team].self, from: decodedData)
                }
            }
            return nil
        }
    }
    static var CurrentSchedule: [ScheduleItem]? {
        set(schedule) {
            if let schedule = schedule {
                do {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(schedule), forKey: "schedule")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "schedule")
            }
        }
        get {
            if let decodedData = UserDefaults.standard.value(forKey: "schedule") as? Data {
                do {
                    return try? PropertyListDecoder().decode([ScheduleItem].self, from: decodedData)
                }
            }
            return nil
        }
    }
    
    func logout() {
        Configuration.CurrentStudent = nil
        Configuration.CurrentTicket = nil
        Configuration.StudentsTickets = nil
        Configuration.CurrentEvent = nil
        Configuration.StudentsEvents = nil
        Configuration.CurrentTeam = nil
        Configuration.StudentTeams = nil
        Configuration.CurrentSchedule = nil
        Networking.shared.jwtToken = nil
    }
}
