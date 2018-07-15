//
//  LeaveTeamViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 14/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class LeaveTeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FindNewTeamMemberViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamDescription: UILabel!
    @IBOutlet weak var btnLeaveTeam: UIButton!
    @IBOutlet weak var btnSendInvitations: UIButton!
    var unsentInvitations: [Student]! = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLeaveTeam.alpha = 0.5
        btnLeaveTeam.isEnabled = false
        
        btnSendInvitations.isHidden = true
        
        refreshCurrentTeam()
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
                    Configuration.CurrentTeam = nil
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSendInvitationsTapped() {
        
        guard let team = Configuration.CurrentTeam else { return }
        
        var invitationsRemaining = unsentInvitations.count
        
        for student in unsentInvitations {
            Networking.shared.inviteUserToTeam(teamId: team.id, userId: student.id) { (error) in
                if let error = error {
                    // TODO: better handle error
                    let alert = UIAlertController(title: "Team Invite Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    invitationsRemaining -= 1
                    
                    if invitationsRemaining == 0 {
                        let alert = UIAlertController(title: "Invitations Sent", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.unsentInvitations.removeAll()
                    }
                    
                    self.refreshCurrentTeam()
                }
            }
        }
    }
    
    func refreshCurrentTeam() {
        
        guard let student = Configuration.CurrentStudent else { return }
        guard let event = Configuration.CurrentEvent else { return }
        
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
                
                
                var contentInsert:CGFloat = 0
                if self.unsentInvitations.count > 0 {
                    self.btnSendInvitations.isHidden = false
                    contentInsert = self.view.frame.size.height - self.btnLeaveTeam.frame.origin.y
                } else {
                    self.btnSendInvitations.isHidden = true
                    contentInsert = self.view.frame.size.height - self.btnLeaveTeam.frame.origin.y
                }
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentInsert, right: 0)

                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let team = Configuration.CurrentTeam else { return 0 }
        
        if section == 0 {
            return team.members.count
        } else if section == 1 {
            return team.pendingInvitations.count
        } else if section == 2 {
            return unsentInvitations.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let team = Configuration.CurrentTeam else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell") as! TeamMemberTableViewCell
        if indexPath.section == 0 {
            cell.populate(withStudent: team.members[indexPath.row])
        } else if indexPath.section == 1 {
            cell.populate(withStudent: team.pendingInvitations[indexPath.row])
        } else if indexPath.section == 2 {
            cell.populate(withStudent: unsentInvitations[indexPath.row])
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "FindNewTeamMemberCell")!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let team = Configuration.CurrentTeam else { return "" }
        
        if section == 0 && team.members.count > 0 {
            return "MEMBERS"
        } else if section == 1 && team.pendingInvitations.count > 0 {
            return "PENDING INVITATIONS"
        } else if section == 2 && unsentInvitations.count > 0 {
            return "UNSENT INVITATIONS"
        }
        return ""
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let team = Configuration.CurrentTeam else { return }
        
        Networking.shared.getEventAttendees(byEventId: team.eventId) { (error, eventAttendees) in
            if let error = error {
                // TODO: better handle error
                let alert = UIAlertController(title: "Student Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                // Present a tableview of all students available to invite to the team
                let findNewTeamMemberVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "FindNewTeamMemberViewController") as! FindNewTeamMemberViewController
                findNewTeamMemberVC.populate(withStudents: eventAttendees, delegate: self)
                self.navigationController?.pushViewController(findNewTeamMemberVC, animated: true)
            }
        }
    }
    
    // MARK: - FindNewTeamMemberViewControllerDelegate
    
    func findNewTeamMemberSelected(student: Student) {
        btnSendInvitations.isHidden = false
        
        unsentInvitations.append(student)
        tableView.reloadData()
    }
}
