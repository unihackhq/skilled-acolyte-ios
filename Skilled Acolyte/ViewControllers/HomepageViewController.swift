//
//  HomepageViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import UserNotifications
import PushNotifications

class HomepageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var btnSettings: UIButton!
    
    var tableViewTitles: [String]! = [String]()
    var tableViewData: [String:Any] = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable swipe back navigation option
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        tabBarController?.tabBar.tintColor = UIColor.gray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        lblEventName.text = ""
        btnSettings.isHidden = true
        
        guard let student = Configuration.CurrentStudent else { return }
        
        // Load the latest student data
        Networking.shared.getStudent(byId: student.id) { (error, student) in
            
            if let error = error {
                Tools().showError(title: "Student Error", error: error, view: self.view)
            }
            guard let student = student else { return }
                
            // Load the student's events
            Networking.shared.getStudentEvents(byStudentId: student.id) { (error, events) in
                
                if let error = error {
                    Tools().showError(title: "Event Error", error: error, view: self.view)
                }
                Configuration.StudentsEvents = events
                    
                // Update the current event. If there is none use the first event found
                if let currentEvent = Configuration.CurrentEvent {
                    for event in events {
                        if event.id == currentEvent.id {
                            Configuration.CurrentEvent = event
                            break
                        }
                    }
                } else if let firstEvent = events.first {
                    Configuration.CurrentEvent = firstEvent
                }
                guard let selectedEvent = Configuration.CurrentEvent else { return }
                
                // Download and match up any teams the student has
                Networking.shared.getStudentTeams(byStudentId: student.id) { (error, teams) in
                    
                    if let error = error {
                        Tools().showError(title: "Team Error", error: error, view: self.view)
                    }
                    
                    Configuration.StudentTeams = teams
                    if let currentTeam = Configuration.CurrentTeam {
                        // Update the current team
                        for team in teams {
                            if team.id == currentTeam.id {
                                Configuration.CurrentTeam = team
                                break
                            }
                        }
                    } else {
                        // Ensure we are setting a team for this event
                        for team in teams {
                            if team.eventId == selectedEvent.id {
                                Configuration.CurrentTeam = team
                                break
                            }
                        }
                    }
                }
                
                // Download and match up the schedule for this event
                Networking.shared.getEventSchedule(byEventId: selectedEvent.id, completion: { (error, schedule) in
                    
                    if let error = error {
                        Tools().showError(title: "Event Schedule Error", error: error, view: self.view)
                    }
                    
                    Configuration.CurrentSchedule = schedule
                    self.refreshPage(student: student, event: selectedEvent, schedule: schedule)
                })
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let student = Configuration.CurrentStudent,
            let event = Configuration.CurrentEvent,
            let schedule = Configuration.CurrentSchedule {
            refreshPage(student: student, event: event, schedule: schedule)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshPage(student: Student, event: Event, schedule: [ScheduleItem]) {
        
        // Refresh Student
        btnSettings.isHidden = false
        // Try to load in an image
        if let image = student.downloadPhoto() {
            btnSettings.setImage(image, for: .normal)
            btnSettings.imageView?.contentMode = .scaleAspectFill
            btnSettings.setTitle("", for: .normal)
        } else {
            // Otherwise use the initials in it's place
            let initials = student.initials()
            btnSettings.setTitle(initials, for: .normal)
        }
        
        // Refresh Event
        self.lblEventName.text = event.name
        if let eventColour = event.logoColour {
            tabBarController?.tabBar.tintColor = Tools().uiColor(fromHex: eventColour)
        }

        // Refresh Schedule
        var nextOnSchedule: ScheduleItem?
        var afterOnSchedule: ScheduleItem?
        var laterOnSchedule: ScheduleItem?
        var nextTechTalk: ScheduleItem?
        var nextHackathonToDo: Any?
        
        for scheduleItem in schedule {
            if nextOnSchedule == nil {
                nextOnSchedule = scheduleItem
            }
            if afterOnSchedule == nil && nextOnSchedule != nil && scheduleItem != nextOnSchedule! {
                afterOnSchedule = scheduleItem
            }
            if laterOnSchedule == nil && afterOnSchedule != nil && scheduleItem != afterOnSchedule! {
                laterOnSchedule = scheduleItem
            }
            if nextTechTalk == nil && scheduleItem.type == ScheduleItemType.TechTalk {
                nextTechTalk = scheduleItem
            }
            // TOOD: next hackathon todo
        }
        
        tableViewTitles = [String]()
        tableViewData = [String:Any]()
        checkPushNotificationStatus()
        if let nextOnSchedule = nextOnSchedule {
            tableViewData["Next Up"] = nextOnSchedule
            tableViewTitles.append("Next Up")
        }
        if let afterOnSchedule = afterOnSchedule {
            tableViewData["After"] = afterOnSchedule
            tableViewTitles.append("After")
        }
        if let laterOnSchedule = laterOnSchedule {
            tableViewData["Later"] = laterOnSchedule
            tableViewTitles.append("Later")
        }
        if let nextTechTalk = nextTechTalk {
            tableViewData["Tech Talks"] = nextTechTalk
            tableViewTitles.append("Tech Talks")
        }
        if let nextHackathonToDo = nextHackathonToDo {
            tableViewData["To Do"] = nextHackathonToDo
            tableViewTitles.append("To Do")
        }
        
        tableView.reloadData()
    }
    
    func checkPushNotificationStatus() {
        
        DispatchQueue.main.async {
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                self.removeCell(withData: "Enable Push Notifications")
            } else if !self.tableViewTitles.contains("Enable Push Notifications") {
                self.tableViewTitles.append("Enable Push Notifications")
                self.tableView.reloadData()
            }
        }
    }
    
    func removeCell(withData data: String) {
        
        if let indexToRemove = tableViewTitles.index(of: data) {
            tableViewTitles.remove(at: indexToRemove)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func btnSettingsTapped() {
        
        let settingsPage = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsNavigationController")
        self.present(settingsPage, animated: true, completion: nil)
    }
    
    func enablePushNotificationsTapped() {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Remove this cell since it is request once only
            self.removeCell(withData: "Enable Push Notifications")

            guard granted else {
                print("Failed to grant push notifications")
                if let error = error {
                    print(error)
                }
                Tools().showErrorMessage(title: "Access Denied", message: "You can enable push notifications from the settings app later", view: self.view)
                return
            }

            // Granted!
            DispatchQueue.main.async {
                PushNotifications.shared.registerForRemoteNotifications()
                
            }
        }
    }
    
    func nextUpTapped(scheduleItem: ScheduleItem) {

        let scheduleItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleItemViewController") as! ScheduleItemViewController
        navigationController?.pushViewController(scheduleItemVC, animated: true)
        scheduleItemVC.populate(with: scheduleItem)
    }

    func techTalksTapped(scheduleItem: ScheduleItem) {

        let scheduleItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleItemViewController") as! ScheduleItemViewController
        navigationController?.pushViewController(scheduleItemVC, animated: true)
        scheduleItemVC.populate(with: scheduleItem)
    }

    func toDoTapped() {

    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = tableViewTitles[indexPath.row]
        if title == "Enable Push Notifications" {
            return tableView.dequeueReusableCell(withIdentifier:"EnablePushNotificationsCell")!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.populate(withTitle: title, content: tableViewData[title])
        
        if let currentEvent = Configuration.CurrentEvent, let eventColour = Tools().uiColor(fromHex: currentEvent.logoColour) {
            cell.colouredView.backgroundColor = eventColour
            // Vary the strength of the colour for alternating cells
            if indexPath.row % 2 == 0 {
                cell.colouredView.alpha = 0.2
            } else {
                cell.colouredView.alpha = 0.3
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = tableViewTitles[indexPath.row]
        let content = tableViewData[title]
        
        if title == "Enable Push Notifications" {
            enablePushNotificationsTapped()
        } else if (title == "Next Up" || title == "After" || title == "Later"), let content = content as? ScheduleItem {
            nextUpTapped(scheduleItem: content)
        } else if title == "Tech Talks", let content = content as? ScheduleItem {
            techTalksTapped(scheduleItem: content)
        } else if title == "To Do" {
            toDoTapped()
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Enables the navigation swipe back feature
        return true
    }
}
