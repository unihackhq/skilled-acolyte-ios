//
//  EventInfoViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 17/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let event = Configuration.CurrentEvent else { return 0 }
        return event.eventInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let event = Configuration.CurrentEvent else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventInfoTableViewCell") as! EventInfoTableViewCell
        cell.populate(withInfo: event.eventInfo[indexPath.row])
        
        // Colour the cells
        if let currentEvent = Configuration.CurrentEvent, let eventColour = Tools().uiColor(fromHex: currentEvent.logoColour) {
            cell.colouredView.backgroundColor = eventColour
            // Vary the strength of the colour for alternating cells
            if indexPath.row % 2 == 0 {
                cell.colouredView.alpha = 0.2
            } else {
                cell.colouredView.alpha = 0.3
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let event = Configuration.CurrentEvent else { return }
        
        let eventInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventInfoItemViewController") as! EventInfoItemViewController
        eventInfoVC.populate(withEventInfoItem: event.eventInfo[indexPath.row])
        
        navigationController?.pushViewController(eventInfoVC, animated: true)
    }
}
