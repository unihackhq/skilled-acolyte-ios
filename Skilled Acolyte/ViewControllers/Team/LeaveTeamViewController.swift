//
//  LeaveTeamViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 14/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class LeaveTeamViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamDescription: UILabel!
    @IBOutlet weak var btnLeaveTeam: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let student = Configuration.CurrentStudent else { return }
        guard let event = Configuration.CurrentEvent else { return }
        
        btnLeaveTeam.alpha = 0.5
        btnLeaveTeam.isEnabled = false
        
        // Refresh the current teams
        Networking.shared.getStudentTeams(byStudentId: student.id) { (error, teams) in
            
            if let error = error {
                let alert = UIAlertController(title: "Team Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                Configuration.StudentTeams = teams
                
                var currentTeam: Team?
                for team in teams {
                    if team.eventId == event.id {
                        currentTeam = team
                        break
                    }
                }
                Configuration.CurrentTeam = currentTeam
                
                guard currentTeam != nil else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
                self.teamName.text = currentTeam!.name
                self.teamDescription.text = (currentTeam!.shortDescription != "") ? currentTeam!.shortDescription : (currentTeam!.longDescription ?? "")
                
                self.btnLeaveTeam.alpha = 1
                self.btnLeaveTeam.isEnabled = true
            }
        }
    }
    
    @IBAction func btnBackTapped() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLeaveTeamTapped() {
        
        guard let team = Configuration.CurrentTeam else { return }
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to leave this team?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { (action) in
            guard let student = Configuration.CurrentStudent else { return }
            Networking.shared.leaveTeam(forStudentId: student.id, teamId: team.id, completion: { (error) in
                if let error = error {
                    // TODO: better handle error
                    let alert = UIAlertController(title: "Leave Team Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let team = Configuration.CurrentTeam else { return 0 }
        
        if section == 0 {
            return team.members.count
        } else {
            return team.pendingInvitations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let team = Configuration.CurrentTeam else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell") as! TeamMemberTableViewCell
        if indexPath.section == 0 {
            cell.populate(withStudent: team.members[indexPath.row])
        } else {
            cell.populate(withStudent: team.pendingInvitations[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let team = Configuration.CurrentTeam else { return "" }
        
        if section == 0 && team.members.count > 0 {
            return "MEMBERS"
        } else if section == 1 && team.pendingInvitations.count > 0 {
            return "PENDING INVITATIONS"
        }
        return ""
    }
}
