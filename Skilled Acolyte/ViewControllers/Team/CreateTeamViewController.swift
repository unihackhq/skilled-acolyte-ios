//
//  CreateTeamViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 8/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class CreateTeamViewController: UIViewController {

    @IBOutlet weak var btnTeamIcon: UIButton!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    var newTeam: Team! = Team()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let event = Configuration.CurrentEvent else { return }
        
        newTeam.eventId = event.id
        
        // Without a team name, the next button is disabled by default
        btnNext.alpha = 0.5
        btnNext.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTeamIconTapped() {
        
        let alert = UIAlertController(title: "Set Icon", message: "Enter the url of an image for your team", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .URL
        }
        alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { (action) in
            let textField = alert.textFields!.first!
            if let urlText = textField.text {
                
                // Download the image with 'strict' validation
                guard let url = URL(string: urlText) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                
                // If successful, set the image, remove the text, and save the url
                self.btnTeamIcon.setImage(image, for: .normal)
                self.btnTeamIcon.setAttributedTitle(NSAttributedString(), for: .normal)
                self.btnTeamIcon.clipsToBounds = true
                self.btnTeamIcon.imageView?.contentMode = .scaleAspectFill
                self.newTeam.photoUrl = urlText
                
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnNextTapped() {
        
        let inviteMembersVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "InviteToTeamViewController") as! InviteToTeamViewController
        inviteMembersVC.populate(withNewTeam: newTeam)
        navigationController?.pushViewController(inviteMembersVC, animated: true)
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldDidType() {
        
        newTeam.name = teamName.text ?? ""
        
        // Enable the next button when the name has been entered
        if newTeam.name != "" {
            btnNext.alpha = 1
            btnNext.isEnabled = true
        } else {
            btnNext.alpha = 0.5
            btnNext.isEnabled = false
        }
    }
    
    @IBAction func textFieldDidReturn() {
        teamName.resignFirstResponder()
    }
}
