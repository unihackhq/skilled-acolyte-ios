//
//  SettingsViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCloseTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    func userTapped() {
        
        let eventsPage = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "ConfirmDetailsViewController")
        navigationController?.pushViewController(eventsPage, animated: true)
    }
    
    func notificationsTapped() {
        
    }
    
    func teamTapped() {
        
    }
    
    func eventsTapped() {
        
        let eventsPage = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "EventsViewController")
        navigationController?.pushViewController(eventsPage, animated: true)
    }
    
    func signOutTapped() {
        
        Configuration.CurrentStudent = nil
        Configuration.CurrentTeam = nil
        Configuration.CurrentEvent = nil
        Configuration.CurrentTicket = nil
        
        let signInPage = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.view.window?.rootViewController = signInPage
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
            guard let student = Configuration.CurrentStudent?.user else {
                cell!.textLabel?.text = "Student not found"
                return cell!
            }
            
            let first = student.firstName ?? ""
            let last = student.lastName ?? ""
            
            cell!.textLabel?.text = first+" "+last
            cell!.detailTextLabel?.text = student.email
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
}
