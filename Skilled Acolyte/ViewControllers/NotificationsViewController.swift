//
//  NotificationsViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 10/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import PushNotifications
import UserNotifications

class NotificationsViewController: UIViewController {

    @IBOutlet weak var allNotificationsSwitch: UISwitch!
    @IBOutlet weak var sessionNotificationsSwitch: UISwitch!
    @IBOutlet weak var techTalkNotificationsSwitch: UISwitch!
    @IBOutlet weak var lunchDinnerNotificationsSwitch: UISwitch!
    @IBOutlet weak var otherNotificationsSwitch: UISwitch!
    let pushNotifications = PushNotifications.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSwitchSettings(animated: false)
    }

    func enablePushNotifications() {
        
        if UIApplication.shared.isRegisteredForRemoteNotifications == false {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                
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
                
                // Granted! Safely call UIApplication inside main thread
                DispatchQueue.main.async {
                    PushNotifications.shared.registerForRemoteNotifications()
                }
            }
        }
        
    }
    
    func loadSwitchSettings(animated: Bool) {
        
        guard let event = Configuration.CurrentEvent else { return }
        
        sessionNotificationsSwitch.setOn(UserDefaults.standard.bool(forKey: event.id+"-"+ScheduleItemType.Session), animated: animated)
        techTalkNotificationsSwitch.setOn(UserDefaults.standard.bool(forKey: event.id+"-"+ScheduleItemType.TechTalk), animated: animated)
        lunchDinnerNotificationsSwitch.setOn(UserDefaults.standard.bool(forKey: event.id+"-"+ScheduleItemType.Special), animated: animated)
        otherNotificationsSwitch.setOn(UserDefaults.standard.bool(forKey: event.id+"-"+ScheduleItemType.Other), animated: animated)
        
        // Enable the all notifications switch if any other switch is on
        let notificationsOn = ( sessionNotificationsSwitch.isOn ||
                                techTalkNotificationsSwitch.isOn ||
                                lunchDinnerNotificationsSwitch.isOn ||
                                otherNotificationsSwitch.isOn)
        allNotificationsSwitch.setOn(notificationsOn, animated: animated)
    }
    
    func saveNotificationSettings() {
        
        guard let event = Configuration.CurrentEvent else { return }
        
        if sessionNotificationsSwitch.isOn {
            try? self.pushNotifications.subscribe(interest: event.id+"-"+ScheduleItemType.Session)
        } else {
            try? self.pushNotifications.unsubscribe(interest: event.id+"-"+ScheduleItemType.Session)
        }
        if techTalkNotificationsSwitch.isOn {
            try? self.pushNotifications.subscribe(interest: event.id+"-"+ScheduleItemType.TechTalk)
        } else {
            try? self.pushNotifications.unsubscribe(interest: event.id+"-"+ScheduleItemType.TechTalk)
        }
        if lunchDinnerNotificationsSwitch.isOn {
            try? self.pushNotifications.subscribe(interest: event.id+"-"+ScheduleItemType.Special)
        } else {
            try? self.pushNotifications.unsubscribe(interest: event.id+"-"+ScheduleItemType.Special)
        }
        if otherNotificationsSwitch.isOn {
            try? self.pushNotifications.subscribe(interest: event.id+"-"+ScheduleItemType.Other)
        } else {
            try? self.pushNotifications.unsubscribe(interest: event.id+"-"+ScheduleItemType.Other)
        }
        
        UserDefaults.standard.set(sessionNotificationsSwitch.isOn, forKey: event.id+"-"+ScheduleItemType.Session)
        UserDefaults.standard.set(techTalkNotificationsSwitch.isOn, forKey: event.id+"-"+ScheduleItemType.TechTalk)
        UserDefaults.standard.set(lunchDinnerNotificationsSwitch.isOn, forKey: event.id+"-"+ScheduleItemType.Special)
        UserDefaults.standard.set(otherNotificationsSwitch.isOn, forKey: event.id+"-"+ScheduleItemType.Other)
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        
        if sender == allNotificationsSwitch {
            // This switch should enable/disable all other notifications
            enablePushNotifications()
            
            sessionNotificationsSwitch.setOn(sender.isOn, animated: true)
            techTalkNotificationsSwitch.setOn(sender.isOn, animated: true)
            lunchDinnerNotificationsSwitch.setOn(sender.isOn, animated: true)
            otherNotificationsSwitch.setOn(sender.isOn, animated: true)
            
        } else {
            allNotificationsSwitch.setOn(true, animated: true)
            // Turning on any switch should turn on important messages
            if sender.isOn {
                otherNotificationsSwitch.setOn(sender.isOn, animated: true)
            }
        }
        
        saveNotificationSettings()
    }
}
