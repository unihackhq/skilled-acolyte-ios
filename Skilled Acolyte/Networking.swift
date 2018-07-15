//
//  Networking.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 20/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import Foundation
import SVProgressHUD

class Networking: NSObject {
    
    static let shared = Networking()
    private override init() {}
    
    struct Methods {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DETET = "DELETE"
    }
    
    let session: URLSession! = URLSession(configuration: URLSessionConfiguration.default)
    var jwtToken: String? {
        set(jwt) {
            UserDefaults.standard.set(jwt, forKey: "jwtToken")
        }
        get {
            if let jwt = UserDefaults.standard.object(forKey: "jwtToken") as? String {
                return jwt
            }
            return nil
        }
    }
    
    // MARK: Unihack API requests
    // Login
    func login(email: String, completion:((Error?) -> Void)?) {
        
        let url = "/token/\(email)"
        request(method: Methods.POST, url: url, body: nil, secure: false) { (error, response) in
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error)
            }
        }
    }
    
    func verifyLoginToken(token: String, completion:((Error?, String?) -> Void)?) {
        
        request(method: Methods.POST, url: "/token", body: ["token":token], secure: false) { (error, response) in
            
            if let response = response as? [String:Any],
                let jwt = response["token"] as? String {
                self.jwtToken = jwt
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, self.jwtToken)
            }
        }
    }
    
    // Student
    func getStudent(byId studentId: String, completion:((Error?, Student?) -> Void)?) {
        
        let url = "/students/\(studentId)"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var student: Student?
            if let response = response as? [String:Any] {
                student = Student(data: response)
                // TODO: Store student for current student easy access. UserDefaults?
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, student)
            }
        }
    }
    
    func getStudentTickets(byStudentId studentId: String, completion:((Error?, [Ticket]) -> Void)?) {
        
        let url = "/students/\(studentId)/tickets"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var tickets: [Ticket] = [Ticket]()
            if let response = response as? [[String:Any]] {
                // Loop through and build tickets out of the response
                for jsonTicket in response {
                    let ticket = Ticket(data: jsonTicket)
                    tickets.append(ticket)
                }
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, tickets)
            }
        }
    }
    
    func getStudentEvents(byStudentId studentId: String, completion:((Error?, [Event]) -> Void)?) {
        
        let url = "/students/\(studentId)/events"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var events: [Event] = [Event]()
            if let response = response as? [[String:Any]] {
                // Loop through and build events out of the response
                for jsonEvent in response {
                    let event = Event(data: jsonEvent)
                    events.append(event)
                }
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, events)
            }
        }
    }
    
    func getStudentTeams(byStudentId studentId: String, completion:((Error?, [Team]) -> Void)?) {
        
        let url = "/students/\(studentId)/teams"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var teams: [Team] = [Team]()
            if let response = response as? [[String:Any]] {
                // Loop through and build teams out of the response
                for jsonTeam in response {
                    let team = Team(data: jsonTeam)
                    teams.append(team)
                }
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, teams)
            }
        }
    }
    
    func getStudentInvites(byStudentId studentId: String, completion:((Error?, [Team]) -> Void)?) {
        
        let url = "/students/\(studentId)/invites"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var teams: [Team] = [Team]()
            if let response = response as? [[String:Any]] {
                // Loop through and build teams out of the response
                for jsonTeam in response {
                    let team = Team(data: jsonTeam)
                    teams.append(team)
                }
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, [])
            }
        }
    }
    
    func updateStudent(student: Student, completion:((Error?, Student?) -> Void)?) {
        
        let url = "/students/\(student.id)"
        request(method: Methods.PUT, url: url, body: student.toJSON(), secure: true) { (error, response) in
            
            var updatedStudent: Student?
            
            if !self.handleIfError(error: error, response: response),
                let response = response as? [String:Any] {
                updatedStudent = Student(data: response)
                // Save the current student to disk
                Configuration.CurrentStudent = updatedStudent
            }
            if let completion = completion {
                completion(error, updatedStudent)
            }
        }
    }
    
    func getEventAttendees(byEventId eventId: String, completion:((Error?, [Student]) -> Void)?) {
        
        let url = "/events/\(eventId)/attendees"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var students: [Student] = [Student]()
            if let response = response as? [[String:Any]] {
                // Loop through and build events out of the response
                for jsonStudent in response {
                    let student = Student(data: jsonStudent)
                    students.append(student)
                }
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, students)
            }
        }
    }
    
    // Ticket
    func getTicket(byId ticketId: String, completion:((Error?, Ticket?) -> Void)?) {
        
        let url = "/tickets/\(ticketId)"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var ticket: Ticket?
            if let response = response as? [String:Any] {
                ticket = Ticket(data: response)
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, ticket)
            }
        }
    }
    
    func transferTicket(withId ticketId: String, toEmail email:String!, completion:((Error?, Ticket?) -> Void)?) {
        
        let url = "/tickets/\(ticketId)/transfer"
        request(method: Methods.POST, url: url, body: ["email":email], secure: true) { (error, response) in
            
            var ticket: Ticket?
            if let response = response as? [String:Any] {
                ticket = Ticket(data: response)
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, ticket)
            }
        }
    }
    
    // Team
    func createTeam(team: Team, completion:((Error?, Team?) -> Void)?) {
        
        request(method: Methods.GET, url: "/teams", body: team.toJSON(), secure: true) { (error, response) in
            
            var team: Team?
            if let response = response as? [String:Any],
                let jsonTeam = response["team"] as? [String:Any] {
                team = Team(data: jsonTeam)
                Configuration.CurrentTeam = team
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, team)
            }
        }
    }
    
    func getTeam(byId teamId: String, completion:((Error?, Team?) -> Void)?) {
        
        let url = "/teams/\(teamId)"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var team: Team?
            if let response = response as? [String:Any] {
                team = Team(data: response)
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, team)
            }
        }
    }
    
    func getTeamInvites(byTeamId teamId: String, completion:((Error?, [Team]?) -> Void)?) {
        
        let url = "/teams/\(teamId)/invites"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var teams: [Team] = [Team]()
            if let response = response as? [[String:Any]] {
                // Loop through and build teams out of the response
                for jsonTeam in response {
                    let team = Team(data: jsonTeam)
                    teams.append(team)
                }
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, [])
            }
        }
    }
    
    func getTeamMembers(byTeamId teamId: String, completion:((Error?, [Student]?) -> Void)?) {
        
        let url = "/teams/\(teamId)/members"
        request(method: Methods.GET, url: url, body: nil, secure: true) { (error, response) in
            
            var students: [Student] = [Student]()
            if let response = response as? [[String:Any]] {
                // Loop through and build students out of the response
                for jsonStudent in response {
                    let student = Student(data: jsonStudent)
                    students.append(student)
                }
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, students)
            }
        }
    }
    
    func updateTeam(team: Team, completion:((Error?, Team?) -> Void)?) {
        
        let url = "/teams/\(team.id)"
        request(method: Methods.PUT, url: url, body: team.toJSON(), secure: true) { (error, response) in
            
            var updatedTeam: Team?
            if let response = response as? [String:Any] {
                updatedTeam = Team(data: response)
            }
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error, updatedTeam)
            }
        }
    }
    
    func inviteUserToTeam(teamId: String, userId: String, completion:((Error?) -> Void)?) {
        
        let url = "/teams/\(teamId)/invites"
        request(method: Methods.POST, url: url, body: ["userId":userId], secure: true) { (error, response) in
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error)
            }
        }
    }
    
    func acceptTeamInvite(forStudentId studentId: String, teamId: String, completion:((Error?) -> Void)?) {
        
        let url = "/students/\(studentId)/invites/\(teamId)/accept"
        request(method: Methods.POST, url: url, body: nil, secure: true) { (error, response) in
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error)
            }
        }
    }
    
    func rejectTeamInvite(forStudentId studentId: String, teamId: String, completion:((Error?) -> Void)?) {
        
        let url = "/students/\(studentId)/invites/\(teamId)/reject"
        request(method: Methods.POST, url: url, body: nil, secure: true) { (error, response) in
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error)
            }
        }
    }
    
    func leaveTeam(forStudentId studentId: String, teamId: String, completion:((Error?) -> Void)?) {
        
        let url = "/students/\(studentId)/teams/\(teamId)/leave"
        request(method: Methods.POST, url: url, body: nil, secure: true) { (error, response) in
            
            self.handleIfError(error: error, response: response)
            if let completion = completion {
                completion(error)
            }
        }
    }
    
    // MARK: Generic HTTP requests
    
    func request(method httpMethod:String, url:String, body:[String:Any]?, secure:Bool, completion:((Error?, Any?) -> Void)?) {
        
        // Build a http request with a url, method, body, and headers
        let request = NSMutableURLRequest()
        request.url = buildURL(with: url)
        request.httpMethod = httpMethod
        // Encode the body as json (if it exists)
        if let body = body {
            do {
                let jsonEncode = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonEncode
            } catch {
                print("Failed to encode json: \(error.localizedDescription)")
            }
        }
        // Add the authorization headers
        if secure == true, let jwt = self.jwtToken {
            request.addValue("bearer \(jwt)", forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Show a progress spinner
        SVProgressHUD.show()
        // Make the request (.resume() to start the request)
        session.dataTask(with: request as URLRequest) { (data, response, error) in

            // Unpack data response if it exisits
            var jsonDecode:Any?
            if let data = data {
                do {
                    jsonDecode = try JSONSerialization.jsonObject(with: data, options: [])
                } catch {
                    print("Failed to decode json: \(error.localizedDescription)")
                }
            }
            
            var newError = error
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                newError = NSError(domain: "UnihackDomain", code: httpResponse.statusCode, userInfo: jsonDecode as? [String:Any])
            }
            
            // Call completion on main thread if it exists
            if let completion = completion {
                DispatchQueue.main.async {
                    // Hide the progress spinner
                    SVProgressHUD.dismiss()
                    if let newError = newError {
                        completion(newError, nil)
                    } else if let error = error {
                        completion(error, nil)
                    } else {
                        completion(nil, jsonDecode)
                    }
                }
            }
            
        }.resume()
    }
    
    // MARK: Other Tools
    
    func buildURL(with path:String!) -> URL! {
        if Configuration.Environment == "dev" {
            return URL(string: Constants.HOST_URL_DEV + path)!
        } else if Configuration.Environment == "local" {
            return URL(string: Constants.HOST_URL_LOCAL + path)!
        } else if Configuration.Environment == "local-wifi" {
            return URL(string: Constants.HOST_URL_LOCAL_WIFI + path)!
        } else {
            return URL(string: Constants.HOST_URL + path)!
        }
        
    }
    
    @discardableResult func handleIfError(error:Error?, response:Any?) -> Bool {
        // Check for a formal error, or at least a non 200 http response
        if let error = error {
            print("Encountered error: \(error)")
            return true
        } else if let response = response as? [String:Any],
            let statusCode = response["statusCode"] as? String,
            statusCode != "200" {
            print("Encountered non-OK 200 response: \(response)")
            return true
        }
        return false
    }
}
