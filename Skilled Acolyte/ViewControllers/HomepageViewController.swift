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

class HomepageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var btnSettings: UIButton!
    
    @IBOutlet weak var lblNextUp: UILabel!
    @IBOutlet weak var lblNextTechTalk: UILabel!
    @IBOutlet weak var lblToDo: UILabel!
    
    var tableViewData: [String]! = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewData = [
            "EnablePushNotificationsCell",
            "NextUpCell",
            "NextTechTalkCell",
            "HackathonToDoCell"
        ]
        
        guard let student = Configuration.CurrentStudent else { return }
        
        // Load the student's events
        Networking.shared.getStudentEvents(byStudentId: student.id) { (error, events) in
            
            if let error = error {
                // TODO: better handle error
                let alert = UIAlertController(title: "Event Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                Configuration.StudentsEvents = events
                if events.count > 1 {
                    // TODO: this student has more than one events. show some way for them to switch between events
                }
                
                guard let firstEvent = events.first else { return }
                Configuration.CurrentEvent = firstEvent
                self.lblEventName.text = firstEvent.name
                
                // Download and match up any teams the student has
                Networking.shared.getStudentTeams(byStudentId: student.id) { (error, teams) in
                    
                    if let error = error {
                        let alert = UIAlertController(title: "Team Error", message: "\(error)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        Configuration.StudentTeams = teams
                        for team in teams {
                            if team.eventId == firstEvent.id {
                                Configuration.CurrentTeam = team
                                break
                            }
                        }
                    }
                }
            }
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        guard let student = Configuration.CurrentStudent else { return }
        refreshSettingsButtonForStudent(student)
        
        checkPushNotificationStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshSettingsButtonForStudent(_ student: Student) {
        
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
    }
    
    func checkPushNotificationStatus() {
        
        DispatchQueue.main.async {
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                self.removeCell(withData: "EnablePushNotificationsCell")
            }
        }
    }
    
    func removeCell(withData data: String) {
        
        if let indexToRemove = tableViewData.index(of: data) {
            tableViewData.remove(at: indexToRemove)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [IndexPath(row: indexToRemove, section: 0)], with: .automatic)
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
            self.removeCell(withData: "EnablePushNotificationsCell")

            guard granted else {
                print("Failed to grant push notifications")
                if let error = error {
                    print(error)
                }
                let alert = UIAlertController(title: "Denied", message: "You can enable push notifications from the Settings app later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            // Granted!
            DispatchQueue.main.async {
                PushNotifications.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func nextUpTapped() {

    }

    func techTalksTapped() {

    }

    func toDoTapped() {

    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resuseId = tableViewData[indexPath.row]
        return tableView.dequeueReusableCell(withIdentifier: resuseId)!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.reuseIdentifier == "EnablePushNotificationsCell" {
            enablePushNotificationsTapped()
        } else if cell?.reuseIdentifier == "NextUpCell" {
            nextUpTapped()
        } else if cell?.reuseIdentifier == "NextTechTalkCell" {
            techTalksTapped()
        } else if cell?.reuseIdentifier == "HackathonToDoCell" {
            toDoTapped()
        }
    }
}
