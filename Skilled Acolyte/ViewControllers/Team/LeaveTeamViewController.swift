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
    var team:Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let team = Configuration.CurrentTeam {
            self.team = team
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnBackTapped() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLeaveTeamTapped() {
        
        let alert = UIAlertController(title: "Leave Team", message: "Are you sure you want to leave this team?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { (action) in
            guard let student = Configuration.CurrentStudent else { return }
            Networking.shared.leaveTeam(forStudentId: student.id, teamId: self.team.id, completion: { (error) in
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
    }
    
    // MARK: - UITableViewDataSource
    
    ///// TODO: add pending invitations too
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return team.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamMemberCell") as! TeamMemberTableViewCell
        cell.populate(withStudent: team.members[indexPath.row])
        return cell
    }
}
