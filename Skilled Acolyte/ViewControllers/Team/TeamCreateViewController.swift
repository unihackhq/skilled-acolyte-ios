//
//  TeamCreateViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class TeamCreateViewController: UIViewController {

    @IBOutlet weak var teamCreateIconView: UIImageView!
    @IBOutlet weak var teamCreateTitleLabel: UILabel!
    @IBOutlet weak var teamCreateDescLabel: UILabel!
    @IBOutlet weak var teamCreateNameLabel: UITextField!
    @IBOutlet weak var teamCreateConfirmButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTeam(_ sender: Any) {
        
        guard let teamName = teamCreateNameLabel.text else { return }
        guard let currentEvent = Configuration.CurrentEvent else { return }
        
        var newTeam = Team(data: nil)
        newTeam.name = teamName
        newTeam.teamDescription = " "
        newTeam.eventId = currentEvent.id
        
        Networking.shared.createTeam(team: newTeam) { (error, team) in
            
            if let _ = error {
                // TODO: handle error
            } else if let team = team {
                Configuration.CurrentTeam = team
                self.showManageTeamPage()
            }
        }
    }
    
    func showManageTeamPage() {
        // TODO: add navigation code here that keeps the tab bar in view
    }

}
