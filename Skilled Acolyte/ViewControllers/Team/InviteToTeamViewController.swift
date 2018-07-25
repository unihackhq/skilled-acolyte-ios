//
//  InviteToTeamViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 8/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class InviteToTeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FindNewTeamMemberViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFinish: UIButton!
    var newTeam: Team!
    var invites: [Student]! = [Student]()
    var eventAttendees: [Student]! = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populate(withNewTeam newTeam: Team) {
        self.newTeam = newTeam
        Networking.shared.getEventAttendees(byEventId: newTeam.eventId) { (error, eventAttendees) in
            if let error = error {
                Tools().showError(title: "Student Error", error: error, view: self.view)
            } else {
                self.eventAttendees = eventAttendees
                self.tableView.reloadData()
            }
        }
    }
    
    func sendInvitations(toTeam team: Team) {
        
        var invitationsRemaining = invites.count
        
        for student in invites {
            Networking.shared.inviteUserToTeam(teamId: team.id, userId: student.user.id, completion: { (error) in
                if let error = error {
                    Tools().showError(title: "Team Invite Error", error: error, view: self.view)
                } else {
                    invitationsRemaining -= 1
                    
                    if invitationsRemaining == 0 {
                        let alert = UIAlertController(title: "Invitations Sent", message: "You made a team. Now all you have to do is win. Good luck! 🦄", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController")
                            self.view.window?.rootViewController = homeVC
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func btnFinishTapped() {
        
        Networking.shared.createTeam(team: newTeam) { (error, team) in
            
            if let error = error {
                Tools().showError(title: "Create Team Error", error: error, view: self.view)
            } else if let team = team {
                self.sendInvitations(toTeam: team)
            }
        }
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // You can invite any number, but only 6 can accept invitations
        return invites.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve an invite if there is one in range
        if indexPath.row < invites.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell") as! TeamMemberTableViewCell
            cell.populate(withStudent: invites[indexPath.row])
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "FindNewTeamMemberCell")!
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.reuseIdentifier == "InviteToTeamCell" {
            
            // Ask the user if they want to remove this invitation
            let alert = UIAlertController(title: "Remove Invite", message: "Are you sure you want to remove this invitation?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                self.invites.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            present(alert, animated: true, completion: nil)
        } else if cell?.reuseIdentifier == "FindNewTeamMemberCell" {
            // Filter the list from current members and sent invitations
            let filteredEventAttendees = eventAttendees.filter({ (filterStudent) -> Bool in
                if filterStudent == Configuration.CurrentStudent {
                    return false
                }
                for invited in invites {
                    if filterStudent == invited {
                        return false
                    }
                }
                return true
            })
            
            // Present a tableview of all students available to invite to the team
            let findNewTeamMemberVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "FindNewTeamMemberViewController") as! FindNewTeamMemberViewController
            findNewTeamMemberVC.populate(withStudents: filteredEventAttendees, delegate: self)
            navigationController?.pushViewController(findNewTeamMemberVC, animated: true)
        }
    }
    
    // MARK: - FindNewTeamMemberTableViewControllerDelegate
    
    func findNewTeamMemberSelected(student: Student) {
        invites.append(student)
        tableView.reloadData()
    }
}
