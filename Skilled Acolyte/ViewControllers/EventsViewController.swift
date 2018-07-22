//
//  EventsViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 1/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var events: [Event]! = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let student = Configuration.CurrentStudent else { return }
        Networking.shared.getStudentEvents(byStudentId: student.id) { (error, events) in
            
            if let error = error {
                // TODO: better handle error
                let alert = UIAlertController(title: "Event Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.events = events
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseId = "SwitchEventCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! SwitchEventTableViewCell
        let event = events[indexPath.row]
        cell.populateWithEvent(event: event)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let event = events[indexPath.row]
        Configuration.CurrentEvent = event
        
        // Get the correct team for this event
        Configuration.CurrentTeam = nil
        if let teams = Configuration.StudentTeams {
            for team in teams {
                if team.eventId == event.id {
                    Configuration.CurrentTeam = team
                    break
                }
            }
        }
        
        // Get the correct schedule for this event
        Networking.shared.getEventSchedule(byEventId: event.id, completion: { (error, schedule) in
            
            if let error = error {
                let alert = UIAlertController(title: "Schedule Error", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            Configuration.CurrentSchedule = schedule
            
            // Finished - leave the page
            self.btnBackTapped()
        })
    }
}
