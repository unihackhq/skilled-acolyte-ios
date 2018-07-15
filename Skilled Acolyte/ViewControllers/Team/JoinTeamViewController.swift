//
//  JoinTeamViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 14/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class JoinTeamViewController: UIViewController, UITableViewDataSource, JoinTeamTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var teamInvitations: [Team]! = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let student = Configuration.CurrentStudent else { return }
        
        Networking.shared.getStudentInvites(byStudentId: student.id) { (error, teamInvitations) in
            
            // TODO: better handle error
            if let error = error {
                let alert = UIAlertController(title: "Invite Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.teamInvitations = teamInvitations
                self.tableView.reloadData()
            }
        }
    }
    
    func removeCell(withTeam team: Team) {
        
        if let indexToRemove = teamInvitations.index(of: team) {
            teamInvitations.remove(at: indexToRemove)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [IndexPath(row: indexToRemove, section: 0)], with: .automatic)
            }
        }
    }
    
    @IBAction func btnBackTapped() {
    
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateTeam() {
        
        let createTeamVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "CreateTeamViewController")
        navigationController?.pushViewController(createTeamVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teamInvitations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let teamInvitation = teamInvitations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JoinTeamCell") as! JoinTeamTableViewCell
        cell.populate(withTeam: teamInvitation, delegate: self)
        
        return cell
    }
    
    // MARK: - JoinTeamTableViewCellDelegate
    
    func joinTeamRequestDidAcceptInvite(team: Team) {
        
        guard let student = Configuration.CurrentStudent else { return }
        
        Networking.shared.acceptTeamInvite(forStudentId: student.id, teamId: team.id) { (error) in
        
            // TODO: better handle error
            if let error = error {
                let alert = UIAlertController(title: "Accept Invite Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                Configuration.CurrentTeam = team
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func joinTeamRequestDidRejectInvite(team: Team) {
        
        guard let student = Configuration.CurrentStudent else { return }
        
        Networking.shared.rejectTeamInvite(forStudentId: student.id, teamId: team.id) { (error) in
            
            // TODO: better handle error
            if let error = error {
                let alert = UIAlertController(title: "Reject Invite Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                // Delete this request and refresh the tableview
                self.removeCell(withTeam: team)
            }
        }
    }
}
