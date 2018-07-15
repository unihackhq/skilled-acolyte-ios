//
//  SettingsViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tableViewData: [[String]]! = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData = [
            [
                "User"
            ],
            [
                "Notifications"
            ],
            [
                "My Team",
                "My Events"
            ],
            [
                "Sign Out"
            ]
        ]
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCloseTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    func userTapped() {
        
        let userDetailsVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "ConfirmDetailsViewController")
        navigationController?.pushViewController(userDetailsVC, animated: true)
    }
    
    func notificationsTapped() {
        
        let notificationsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController")
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    func teamTapped() {
        
        if Configuration.CurrentTeam == nil {
            let findTeamVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "JoinTeamViewController")
            navigationController?.pushViewController(findTeamVC, animated: true)
        } else {
            let leaveTeamVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "LeaveTeamViewController")
            navigationController?.pushViewController(leaveTeamVC, animated: true)
        }
    }
    
    func eventsTapped() {
        
        let eventsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "EventsViewController")
        navigationController?.pushViewController(eventsVC, animated: true)
    }
    
    func signOutTapped() {
        
        Configuration.CurrentStudent = nil
        Configuration.CurrentTeam = nil
        Configuration.CurrentEvent = nil
        Configuration.CurrentTicket = nil
        
        let signInVC = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.view.window?.rootViewController = signInVC
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = tableViewData[indexPath.section][indexPath.row]
        let reuseId = "Settings:"+cellData
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        
        if cell == nil {
            if cellData == "User" {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseId)
            } else {
                cell = UITableViewCell(style: .default, reuseIdentifier: reuseId)
            }
        }
        
        if cellData == "User" {
            guard let student = Configuration.CurrentStudent else {
                cell!.textLabel?.text = "Student not found"
                return cell!
            }
            
            cell!.textLabel?.text = student.fullName()
            cell!.detailTextLabel?.text = student.user.email
        } else {
            cell?.textLabel?.text = cellData
        }
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        if cell?.reuseIdentifier == "Settings:User" {
            userTapped()
        } else if cell?.reuseIdentifier == "Settings:Notifications" {
            notificationsTapped()
        } else if cell?.reuseIdentifier == "Settings:My Team" {
            teamTapped()
        } else if cell?.reuseIdentifier == "Settings:My Events" {
            eventsTapped()
        } else if cell?.reuseIdentifier == "Settings:Sign Out" {
            signOutTapped()
        }
    }

    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Enables the navigation swipe back feature
        return true
    }
}
