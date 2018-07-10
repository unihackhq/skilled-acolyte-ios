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
    @IBOutlet weak var btnShowAllTickets: UIButton!
    var currentTicket: Ticket?
    var currentEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let student = Configuration.CurrentStudent else { return }
        
        // Check for the students current ticket, otherwise ask for a selection
        if let ticket = Configuration.CurrentTicket,
            let event = Configuration.CurrentEvent {
            self.refreshTicket(ticket: ticket, event: event)
        } else {
            // Check the number of tickets the student actually has,
            //  and if it's only one then populate it
            Networking.shared.getStudentEvents(byStudentId: student.id) { (error, events) in
                
                if let error = error {
                    // TODO: better handle error
                    let alert = UIAlertController(title: "Event Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    Configuration.StudentsEvents = events

                    Networking.shared.getStudentTickets(byStudentId: student.id) { (error, tickets) in
                        
                        if let error = error {
                            // TODO: better handle error
                            let alert = UIAlertController(title: "Ticket Error", message: "\(error)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            Configuration.StudentsTickets = tickets
                            
                            // If there's only one ticket just show it on the page
                            if tickets.count == 1,
                                let ticket = tickets.first,
                                let event = events.first {
                                self.refreshTicket(ticket: ticket, event: event)
                            } else {
                                // Show all tickets so the student can choose one to manage
                                self.showAllTicketsPage()
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTicket(ticket: Ticket, event: Event) {
        self.currentTicket = ticket
        self.currentEvent = event
        
        self.lblTicket.text = self.currentEvent!.name+"\n"+self.currentTicket!.ticketType
        
        // Hide the all tickets button if there's only one ticket
        if Configuration.StudentsTickets?.count == 1 {
            btnShowAllTickets.isHidden = true
        } else {
            btnShowAllTickets.isHidden = false
        }
    }
    
    func showAllTicketsPage() {
        let homePage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TicketsViewController")
        self.present(homePage, animated: true, completion: nil)
    }
}
