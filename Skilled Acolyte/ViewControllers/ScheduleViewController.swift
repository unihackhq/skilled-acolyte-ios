//
//  ScheduleViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 19/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableViewData: [ScheduleItem]! = [ScheduleItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let event = Configuration.CurrentEvent else { return }
        
        Networking.shared.getEventSchedule(byEventId: event.id) { (error, schedule) in
            if let error = error {
                // todo: handle error
            } else {
                self.tableViewData = schedule
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleItemCell") as! ScheduleItemTableViewCell
        cell.populate(with: tableViewData[indexPath.row]
)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let scheduleItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleItemViewController") as! ScheduleItemViewController
        scheduleItemVC.populate(with: tableViewData[indexPath.row])
        
        navigationController?.pushViewController(scheduleItemVC, animated: true)
    }
}
