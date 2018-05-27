//
//  TicketsViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 27/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class TicketsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tickets: [Ticket]! = [Ticket]()
    var events: [Event]! = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        // Add the event name and ticket type to the cell
        let ticket = tickets[indexPath.row]
        for event in events {
            if event.id == ticket.eventId {
                cell?.textLabel?.text = event.name
                break
            }
        }
        cell?.detailTextLabel?.text = ticket.ticketType
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ticket = tickets[indexPath.row]
        Configuration.CurrentTicket = ticket
        for event in events {
            if event.id == ticket.eventId {
                Configuration.CurrentEvent = event
                break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
