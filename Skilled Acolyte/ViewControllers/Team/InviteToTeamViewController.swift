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
    var allStudent: [Student]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnFinish.alpha = 0.5
        btnFinish.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populate(withNewTeam newTeam: Team) {
        self.newTeam = newTeam
        Networking.shared.getAllStudents { (error, student) in
            if let error = error {
                // TODO: better handle error
                let alert = UIAlertController(title: "Student Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.allStudent = student
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func btnFinishTapped() {
        
        Networking.shared.createTeam(team: newTeam) { (error, team) in
            
            if let error = error {
                // TODO: better handle error
                let alert = UIAlertController(title: "Create Team Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if let team = team {
                for student in self.invites {
                    Networking.shared.inviteUserToTeam(teamId: team.id, userId: student.user.id, completion: { (error, something) in
                        if let error = error {
                            // TODO: better handle error
                            let alert = UIAlertController(title: "Team Invite Error", message: "\(error)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Congrats :)", message: "You made a team. Unfortunately the next part of the app hasn't been built yet, so instead here's a uniforn 🦄", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Return to home", style: .default, handler: { (action) in
                                let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController")
                                self.view.window?.rootViewController = homeVC
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Maxiumum team size is 6, so only show the 'add' cell when there are fewer students
        if invites.count < 6 {
            return invites.count+1
        } else {
            return invites.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve an invite if there is one in range
        if indexPath.row < invites.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteToTeamCell") as! InviteToTeamTableViewCell
            cell.populateWith(student: invites[indexPath.row])
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
            let alert = UIAlertController(title: "Remove Invite", message: "Are you sure you want to remove this invitation", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                self.invites.remove(at: indexPath.row)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
                if self.invites.count < 4 {
                    self.btnFinish.alpha = 0.5
                    self.btnFinish.isEnabled = false
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        } else if cell?.reuseIdentifier == "FindNewTeamMemberCell" {
            // Present a tableview of all students available to invite to the team
            let findNewTeamMemberVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "FindNewTeamMemberViewController") as! FindNewTeamMemberViewController
            findNewTeamMemberVC.populate(withStudents: invites, delegate: self)
            navigationController?.pushViewController(findNewTeamMemberVC, animated: true)
        }
    }
    
    // MARK: - FindNewTeamMemberTableViewControllerDelegate
    
    func findNewTeamMemberSelected(student: Student) {
        invites.append(student)
        tableView.reloadRows(at: [IndexPath.init(row: invites.count, section: 0)], with: .automatic)
        
        if invites.count >= 4 {
            btnFinish.alpha = 1
            btnFinish.isEnabled = true
        }
    }
}
