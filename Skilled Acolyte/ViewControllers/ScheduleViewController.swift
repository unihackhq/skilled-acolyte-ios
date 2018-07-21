//
//  ScheduleViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 19/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tableViewData: [[ScheduleItem]]! = [[ScheduleItem]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let event = Configuration.CurrentEvent else { return }
        
        Networking.shared.getEventSchedule(byEventId: event.id) { (error, schedule) in
            if let error = error {
                // todo: handle error
            } else {
                
                // Break the schedule up into days
                var eventsByDay = [[ScheduleItem]]()
                var previousEventDay:Int?
                
                
                for scheduleItem in schedule {
                    guard let startDate = scheduleItem.startDate else { continue }
                    
                    // Compare today's day with yesterdays and add a new day if there's a difference
                    let itemDay = NSCalendar.current.component(.day, from: startDate)
                    if let previousEventDay = previousEventDay {
                        if previousEventDay != itemDay {
                            eventsByDay.append([ScheduleItem]())
                        }
                    } else {
                        eventsByDay.append([ScheduleItem]())
                    }
                    previousEventDay = itemDay
                    
                    // Update the schedule for this day
                    var previousScheduleDay = eventsByDay.last!
                    previousScheduleDay.append(scheduleItem)
                    eventsByDay[eventsByDay.count-1] = previousScheduleDay
                    
                }
                
                self.tableViewData = eventsByDay
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleItemCell") as! ScheduleItemTableViewCell
        cell.populate(with: tableViewData[indexPath.section][indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let eventItem = tableViewData[section].first, let startDate = eventItem.startDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: startDate)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let scheduleItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScheduleItemViewController") as! ScheduleItemViewController
        navigationController?.pushViewController(scheduleItemVC, animated: true)
        scheduleItemVC.populate(with: tableViewData[indexPath.section][indexPath.row])
    }
}
