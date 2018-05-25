//
//  Networking.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 20/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation


class Networking: NSObject {
    
    struct Methods {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DETET = "DELETE"
    }
    
    let session: URLSession! = URLSession(configuration: URLSessionConfiguration.default)
    let baseURL: String! = "http://localhost:3000"
    
    
    // MARK: Unihack API requests
    // Login
    func login(email: String!, completion:((Error?) -> Void)?) {
        
        let url = "/token/\(email)"
        request(method: Methods.POST, url: url, body: nil) { (error, response) in
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error)
            }
        }
    }
    
    func verifyLoginToken(token: String!, completion:((Error?) -> Void)?) {
        
        request(method: Methods.POST, url: "/token", body: ["token":token]) { (error, response) in
            
            if let response = response as? [String:Any],
                let jwt = response["token"] {
                // TODO: Store jwt token. UserDefaults?
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error)
            }
        }
    }
    
    // Student
    func getStudent(byId studentId: String!, completion:((Error?, Student?) -> Void)?) {
        
        let url = "/students/\(studentId)"
        request(method: Methods.GET, url: url, body: nil) { (error, response) in
            
            var student: Student?
            if let response = response as? [String:Any] {
                student = Student(data: response)
                // TODO: Store student for current student easy access. UserDefaults?
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, student)
            }
        }
    }
    
    func getStudentTickets(byStudentId studentId: String!, completion:((Error?, [Ticket]) -> Void)?) {
        
        let url = "/students/\(studentId)/tickets"
        request(method: Methods.GET, url: url, body: nil) { (error, response) in
            
            var tickets: [Ticket] = [Ticket]()
            if let response = response as? [[String:Any]] {
                // Loop through and build tickets out of the response
                for jsonTicket in response {
                    let ticket = Ticket(data: jsonTicket)
                    tickets.append(ticket)
                }
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, tickets)
            }
        }
    }
    
    func getStudentEvents(byStudentId studentId: String!, completion:((Error?, [Event]) -> Void)?) {
        
        let url = "/students/\(studentId)/events"
        request(method: Methods.GET, url: url, body: nil) { (error, response) in
            
            var events: [Event] = [Event]()
            if let response = response as? [[String:Any]] {
                // Loop through and build events out of the response
                for jsonEvent in response {
                    let event = Event(data: jsonEvent)
                    events.append(event)
                }
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, events)
            }
        }
    }
    
    func getStudentTeams(byStudentId studentId: String!, completion:((Error?, [Team]) -> Void)?) {
        
        let url = "/students/\(studentId)/teams"
        request(method: Methods.GET, url: url, body: nil) { (error, response) in
            
            var teams: [Team] = [Team]()
            if let response = response as? [[String:Any]] {
                // Loop through and build teams out of the response
                for jsonTeam in response {
                    let team = Team(data: jsonTeam) // TODO: make sure the response actually matches the Team model
                    teams.append(team)
                }
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, teams)
            }
        }
    }
    
    func getStudentTeamInvites(byStudentId studentId: String!, completion:((Error?, [Team]) -> Void)?) {
        // TODO: figure out the model and response
        completion!(nil, [])
    }
    
    func getAllStudents(completion:((Error?, [Student]) -> Void)?) {
        
        request(method: Methods.GET, url: "/students", body: nil) { (error, response) in
            
            var students: [Student] = [Student]()
            if let response = response as? [[String:Any]] {
                // Loop through and build students out of the response
                for jsonStudent in response {
                    let student = Student(data: jsonStudent)
                    students.append(student)
                }
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, students)
            }
        }
    }
    
    func updateStudent(student: Student!, completion:((Error?, Student?) -> Void)?) {
        
        let url = "/students/\(student.id)"
        request(method: Methods.PUT, url: url, body: student.toJSON()) { (error, response) in
            
            var updatedStudent: Student?
            if let response = response as? [String:Any] {
                updatedStudent = Student(data: response)
                // TODO: Store updated student for current student easy access. UserDefaults?
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, updatedStudent)
            }
        }
    }
    
    // Ticket
    func getTicket(byId ticketId: String!, completion:((Error?, Ticket?) -> Void)?) {
        
        let url = "/tickets/\(ticketId)"
        request(method: Methods.GET, url: url, body: nil) { (error, response) in
            
            var ticket: Ticket?
            if let response = response as? [String:Any] {
                ticket = Ticket(data: response)
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, ticket)
            }
        }
    }
    
    func transferTicket(withId ticketId: String!, toEmail email:String!, completion:((Error?, Ticket?) -> Void)?) {
        
        let url = "/tickets/\(ticketId)/transfer"
        request(method: Methods.POST, url: url, body: ["email":email]) { (error, response) in
            
            var ticket: Ticket?
            if let response = response as? [String:Any] {
                ticket = Ticket(data: response)
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, ticket)
            }
        }
    }
    
    // Team
    func createTeam(team: Team!, completion:((Error?, Team?) -> Void)?) {
        
        request(method: Methods.GET, url: "/teams", body: team.toJSON()) { (error, response) in
            
            var team: Team?
            if let response = response as? [String:Any],
                let jsonTeam = response["team"] as? [String:Any] {
                team = Team(data: jsonTeam)
            }
            
            self.handleIfError(error: error)
            if let completion = completion {
                completion(error, team)
            }
        }
    }
    
    // MARK: Generic HTTP requests
    
    func request(method httpMethod:String!, url:String!, body:[String:Any]?, completion:((Error?, Any?) -> Void)?) {
        
        // Build a http request with a url, method, and body
        let request = NSMutableURLRequest()
        request.url = buildURL(with: url)
        request.httpMethod = httpMethod
        // Encode the body as json (if it exists)
        if let body = body {
            do {
                let jsonEncode = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                request.httpBody = jsonEncode
            } catch {
                print("Failed to encode json: \(error.localizedDescription)")
            }
        }

        // Make the request (.resume() to start the request)
        session.dataTask(with: request as URLRequest) { (data, response, error) in

            // Unpack data response if it exisits
            var jsonDecode:[String:Any]?
            if let data = data {
                do {
                    jsonDecode = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? [String : Any]
                } catch {
                    print("Failed to decode json: \(error.localizedDescription)")
                }
            }
            
            // Call completion if it exists
            if let completion = completion {
                completion(error, jsonDecode)
            }
            
        }.resume()
    }
    
    // MARK: Other Tools
    
    func buildURL(with path:String!) -> URL! {
        return URL(string: baseURL + path)!
    }
    
    func handleIfError(error:Error?) {
        guard let error = error else { return }
        print("Encountered error: \(error)")
    }
}
