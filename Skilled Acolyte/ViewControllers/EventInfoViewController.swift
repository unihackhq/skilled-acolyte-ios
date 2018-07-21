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
