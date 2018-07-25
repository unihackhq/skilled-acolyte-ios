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
    var tableViewData: [[Student]]! = [[Student]]()
    var tableViewHeaders: [String]! = [String]()
    
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
                    Tools().showError(title: "Leave Team Error", error: error, view: self.view)
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
                    Tools().showError(title: "Team Invite Error", error: error, view: self.view)
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
                Tools().showError(title: "Team Error", error: error, view: self.view)
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

                self.refreshTableViewData()
            }
        }
    }
    
    func refreshTableViewData() {
        
        guard let team = Configuration.CurrentTeam else { return }
        
        // Create the table view data set
        tableViewData.removeAll()
        tableViewHeaders.removeAll()
        if team.members.count > 0 {
            tableViewData.append(team.members)
            tableViewHeaders.append("MEMBERS")
        }
        if team.pendingInvitations.count > 0 {
            tableViewData.append(team.pendingInvitations)
            tableViewHeaders.append("PENDING INVITATIONS")
        }
        if unsentInvitations.count > 0 {
            tableViewData.append(unsentInvitations)
            tableViewHeaders.append("UNSENT INVITATIONS")
        }
        
        // Add a content insert up to the highest button
        var contentInsert:CGFloat = 0
        if unsentInvitations.count > 0 {
            btnSendInvitations.isHidden = false
            contentInsert = self.view.frame.size.height - self.btnLeaveTeam.frame.origin.y
        } else {
            btnSendInvitations.isHidden = true
            contentInsert = self.view.frame.size.height - self.btnLeaveTeam.frame.origin.y
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentInsert, right: 0)
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // The last section will be to add new members which is not included in the tableViewData
        return tableViewData.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section < tableViewData.count {
            return tableViewData[section].count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell") as! TeamMemberTableViewCell
        if indexPath.section < tableViewData.count {
            cell.populate(withStudent: tableViewData[indexPath.section][indexPath.row])
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "FindNewTeamMemberCell")!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section < tableViewHeaders.count {
            return tableViewHeaders[section]
        }
        
        return ""
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section < tableViewData.count {
            // Check if the tapped cell contained a student in the unsent invitation array
            let student = tableViewData[indexPath.section][indexPath.row]
            if let indexOfStudent = unsentInvitations.index(of: student) {
                let alert = UIAlertController(title: "Remove Invitation", message: "Are you sure you want to remove this invitation?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                    self.unsentInvitations.remove(at: indexOfStudent)
                    self.refreshTableViewData()
                }))
                present(alert, animated: true, completion: nil)
            }
        } else {
            guard let team = Configuration.CurrentTeam else { return }
            Networking.shared.getEventAttendees(byEventId: team.eventId) { (error, eventAttendees) in
                if let error = error {
                    Tools().showError(title: "Student Error", error: error, view: self.view)
                } else {
                    
                    // Filter the list from current members and sent invitations
                    let filteredEventAttendees = eventAttendees.filter({ (filterStudent) -> Bool in
                        for member in team.members {
                            if filterStudent == member {
                                return false
                            }
                        }
                        for invited in team.pendingInvitations {
                            if filterStudent == invited {
                                return false
                            }
                        }
                        return true
                    })
                    
                    // Present a tableview of all students available to invite to the team
                    let findNewTeamMemberVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "FindNewTeamMemberViewController") as! FindNewTeamMemberViewController
                    findNewTeamMemberVC.populate(withStudents: filteredEventAttendees, delegate: self)
                    self.navigationController?.pushViewController(findNewTeamMemberVC, animated: true)
                }
            }
        }
    }
    
    // MARK: - FindNewTeamMemberViewControllerDelegate
    
    func findNewTeamMemberSelected(student: Student) {
        btnSendInvitations.isHidden = false
        
        unsentInvitations.append(student)
        
        refreshTableViewData()
    }
}
