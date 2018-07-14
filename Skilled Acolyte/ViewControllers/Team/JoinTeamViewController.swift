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
    var teamInvitations: [Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let student = Configuration.CurrentStudent else { return }
        
        Networking.shared.getStudentInvites(byStudentId: student.id) { (error, teamInvitations) in
            
            // TODO: handle error
            if let error = error {
                
            } else {
                self.teamInvitations = teamInvitations
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teamInvitations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let teamInvitation = teamInvitations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "") as! JoinTeamTableViewCell
        cell.populate(withTeam: teamInvitation as! Team, delegate: self)
        
        return cell
    }
    
    // MARK: - JoinTeamTableViewCellDelegate
    
    func joinTeamRequestDidAcceptInvite(team: Team) {
        
        guard let student = Configuration.CurrentStudent else { return }
        
        Networking.shared.acceptTeamInvite(forStudentId: student.id, teamId: team.id) { (error) in
        
            if let error = error {
                
            } else {
                // Close screen and show new team page
            }
        }
    }
    
    func joinTeamRequestDidRejectInvite(team: Team) {
        
        guard let student = Configuration.CurrentStudent else { return }
        
        Networking.shared.rejectTeamInvite(forStudentId: student.id, teamId: team.id) { (error) in
            
            if let error = error {
                
            } else {
                // Delete this request and refresh the tableview
            }
        }
    }
}
