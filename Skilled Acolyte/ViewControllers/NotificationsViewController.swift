//
//  NotificationsViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 10/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import PushNotifications

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

    func loadSwitchSettings(animated: Bool) {
        
        guard let event = Configuration.CurrentEvent else { return }
        
        sessionNotificationsSwitch.setOn(UserDefaults.standard.bool(forKey: event.id+"-session"), animated: animated)
        techTalkNotificationsSwitch.setOn(UserDefaults.standard.bool(forKey: event.id+"-techTalk"), animated: animated)
        lunchDinnerNotificationsSwitch.setOn(UserDefaults.standard.bool(forKey: event.id+"-mealsRafflesEtc"), animated: animated)
        otherNotificationsSwitch.setOn(UserDefaults.standard.bool(forKey: event.id+"-importantMessages"), animated: animated)
    }
    
    func saveNotificationSettings() {
        
        guard let event = Configuration.CurrentEvent else { return }
        
        if sessionNotificationsSwitch.isOn {
            try? self.pushNotifications.subscribe(interest: event.id+"-session")
        } else {
            try? self.pushNotifications.unsubscribe(interest: event.id+"-session")
        }
        if techTalkNotificationsSwitch.isOn {
            try? self.pushNotifications.subscribe(interest: event.id+"-techTalk")
        } else {
            try? self.pushNotifications.unsubscribe(interest: event.id+"-techTalk")
        }
        if lunchDinnerNotificationsSwitch.isOn {
            try? self.pushNotifications.subscribe(interest: event.id+"-mealsRafflesEtc")
        } else {
            try? self.pushNotifications.unsubscribe(interest: event.id+"-mealsRafflesEtc")
        }
        if otherNotificationsSwitch.isOn {
            try? self.pushNotifications.subscribe(interest: event.id+"-importantMessages")
        } else {
            try? self.pushNotifications.unsubscribe(interest: event.id+"-importantMessages")
        }
        
        UserDefaults.standard.set(sessionNotificationsSwitch.isOn, forKey: event.id+"-session")
        UserDefaults.standard.set(techTalkNotificationsSwitch.isOn, forKey: event.id+"-techTalk")
        UserDefaults.standard.set(lunchDinnerNotificationsSwitch.isOn, forKey: event.id+"-mealsRafflesEtc")
        UserDefaults.standard.set(otherNotificationsSwitch.isOn, forKey: event.id+"-importantMessages")
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        
        if sender == allNotificationsSwitch {
            // This switch should enable/disable all other notifications
            
            sessionNotificationsSwitch.setOn(sender.isOn, animated: true)
            techTalkNotificationsSwitch.setOn(sender.isOn, animated: true)
            lunchDinnerNotificationsSwitch.setOn(sender.isOn, animated: true)
            otherNotificationsSwitch.setOn(sender.isOn, animated: true)
            
        } else {
            allNotificationsSwitch.setOn(true, animated: true)
        }
        
        saveNotificationSettings()
    }
}
