//
//  ManageTicketViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 27/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class ManageTicketViewController: UIViewController {

    @IBOutlet weak var lblTicket: UILabel!
    var tickets: [Ticket]! = [Ticket]()
    var events: [Event]! = [Event]()
    var currentTicket: Ticket?
    var currentEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Check for the students current ticket, otherwise ask for a selection
        if let ticket = Configuration.CurrentTicket,
            let event = Configuration.CurrentEvent {
            currentTicket = ticket
            currentEvent = event
            lblTicket.text = event.name+"\n"+ticket.ticketType
        } else {
            // Show all tickets so the student can choose one to manage
            showAllTicketsPage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAllTicketsPage() {
        let homePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TicketsViewController")
        self.present(homePage, animated: true, completion: nil)
    }
}
