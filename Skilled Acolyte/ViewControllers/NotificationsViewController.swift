//
//  NotificationsViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 10/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var allNotificationsSwitch: UISwitch!
    @IBOutlet weak var sessionNotificationsSwitch: UISwitch!
    @IBOutlet weak var techTalkNotificationsSwitch: UISwitch!
    @IBOutlet weak var lunchDinnerNotificationsSwitch: UISwitch!
    @IBOutlet weak var otherNotificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TODO: load up notification settings
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        
        var switchToUpdate = ""
        if sender == allNotificationsSwitch {
            switchToUpdate = "allNotifications"
            // This switch should enable/disable all other notifications
            sessionNotificationsSwitch.isEnabled = sender.isOn
            techTalkNotificationsSwitch.isEnabled = sender.isOn
            lunchDinnerNotificationsSwitch.isEnabled = sender.isOn
            otherNotificationsSwitch.isEnabled = sender.isOn
            sessionNotificationsSwitch.alpha = sender.isOn ? 1 : 0.5
            techTalkNotificationsSwitch.alpha = sender.isOn ? 1 : 0.5
            lunchDinnerNotificationsSwitch.alpha = sender.isOn ? 1 : 0.5
            otherNotificationsSwitch.alpha = sender.isOn ? 1 : 0.5
        } else if sender == sessionNotificationsSwitch {
            switchToUpdate = "sessionNotifications"
        } else if sender == techTalkNotificationsSwitch {
            switchToUpdate = "techTalkNotifications"
        } else if sender == lunchDinnerNotificationsSwitch {
            switchToUpdate = "lunchDinnerNotifications"
        } else if sender == otherNotificationsSwitch {
            switchToUpdate = "otherNotifications"
        }
        
        if sender.isOn {
            // TODO: update 'switchToUpdate'
        }
    }
}
