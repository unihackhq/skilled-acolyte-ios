//
//  ScheduleItemViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 19/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class ScheduleItemViewController: UIViewController {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemSubtitle: UILabel!
    @IBOutlet weak var itemType: UILabel!
    @IBOutlet weak var itemContent: UITextView!
    var scheduleItem: ScheduleItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var durationStr = ""
        
        if let startDate = scheduleItem.startDate, let endDate = scheduleItem.endDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            if startDate != endDate {
                durationStr = formatter.string(from: startDate) + " - " + formatter.string(from: endDate)
            } else {
                durationStr = formatter.string(from: startDate)
            }
        }
        
        itemTitle.text = scheduleItem.name
        itemSubtitle.text = durationStr + (scheduleItem.location != nil && scheduleItem.location != "" ? (" - " + scheduleItem.location!) : "")
        itemContent.text = scheduleItem.scheduleDescription
        
        if let scheduleType = scheduleItem.type {
            switch scheduleType {
            case ScheduleItemType.Session:
                itemType.text = "Session   "
            case ScheduleItemType.TechTalk:
                itemType.text = "Tech Talk   "
            case ScheduleItemType.Event:
                itemType.text = "Event   "
            case ScheduleItemType.Special:
                itemType.text = "Special   "
            case ScheduleItemType.Other:
                itemType.text = "Other   "
            default:
                itemType.text = ""
            }
        }
        itemType.isHidden = (scheduleItem.type == nil)
    }
    
    func populate(with scheduleItem: ScheduleItem) {
        
        self.scheduleItem = scheduleItem
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
}
