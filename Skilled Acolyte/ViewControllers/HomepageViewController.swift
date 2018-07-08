//
//  HomepageViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import UserNotifications

class HomepageTableViewController: UITableViewController {

    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var btnSettings: UIButton!
    
    @IBOutlet weak var lblNextUp: UILabel!
    @IBOutlet weak var lblNextTechTalk: UILabel!
    @IBOutlet weak var lblToDo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        guard let student = Configuration.CurrentStudent else { return }
        
        refreshSettingsButtonForStudent(student)
        
        // Load the student's events
        Networking.shared.getStudentEvents(byStudentId: student.id) { (error, events) in
            
            if let _ = error {
                // TODO: handle error
            } else {
                Configuration.StudentsEvents = events
                if events.count > 1 {
                    // TODO: this student has more than one events. show some way for them to switch between events
                } else if events.count == 0 {
                    // this student has no events :(
                    return
                }
                
                let firstEvent = events.first
                Configuration.CurrentEvent = firstEvent
                self.lblEventName.text = firstEvent?.name
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshSettingsButtonForStudent(_ student: Student) {
        // Default to letters. This will be removed if an image is loaded
        let firstName = student.user.firstName ?? ""
        let lastName = student.user.lastName ?? ""
        let firstLetters = String(describing:firstName.first!) + String(describing:lastName.first!)
        btnSettings.setTitle(firstLetters, for: .normal)
        
        // Try to load in an image
        if let imgUrl = student.photoUrl {
            // Download photo and set on button
            guard let data = try? Data(contentsOf: URL(string:imgUrl)!) else { return }
            let image = UIImage(data: data)
            btnSettings.setImage(image, for: .normal)
            btnSettings.clipsToBounds = true
            btnSettings.imageView?.contentMode = .scaleAspectFill
            btnSettings.setTitle("", for: .normal)
        }
    }
    
    func registerPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on iOS 9 and earlier versions
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @IBAction func btnSettingsTapped() {
        
        let settingsPage = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsNavigationController")
        self.present(settingsPage, animated: true, completion: nil)
    }
    
    func enablePushNotificationsTapped() {
        // TODO: register for push notifications
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                guard granted else {
                    print("Failed to grant push notifications")
                    if let error = error {
                        print(error)
                    }
                    return
                }
                
                // Granted!
                self.registerPushNotifications()
            }
        } else {
            // Fallback on iOS 9 and earlier versions
            self.registerPushNotifications()
        }
    }
    
    func nextUpTapped() {

    }

    func techTalksTapped() {

    }

//    func toDoTapped() {
//
//    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.reuseIdentifier == "EnablePushNotificationsCell" {
            enablePushNotificationsTapped()
        } else if cell?.reuseIdentifier == "NextUpCell" {
            nextUpTapped()
        } else if cell?.reuseIdentifier == "NextTechTalkCell" {
            techTalksTapped()
        }
//        else if cell?.reuseIdentifier == "HackathonToDoCell" {
//            toDoTapped()
//        }
    }
}
