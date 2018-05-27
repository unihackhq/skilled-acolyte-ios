//
//  TicketsViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 27/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class TicketsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let student = Configuration.CurrentStudent else { return }
        
        // Get the student's tickets
        Networking.shared.getStudentTickets(byStudentId: student.id) { (error, tickets) in
            
            if let _ = error {
                // TODO: handle error
            } else {
                Configuration.StudentsTickets = tickets
                
                // TODO: show tickets for management
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
