//
//  InviteToTeamViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 8/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class InviteToTeamViewController: UIViewController {

    var newTeam: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateWith(newTeam: Team) {
        self.newTeam = newTeam
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
}
