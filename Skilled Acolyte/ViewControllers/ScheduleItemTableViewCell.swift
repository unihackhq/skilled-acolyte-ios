//
//  ScheduleItemTableViewCell.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 19/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class ScheduleItemTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var type: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populate(with scheduleItem: ScheduleItem) {
        
        var durationStr = ""
        
        if let startDate = scheduleItem.startDate, let endDate = scheduleItem.endDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            durationStr = formatter.string(from: startDate) + " - " + formatter.string(from: endDate) + " - "
        }
        
        title.text = scheduleItem.name
        subtitle.text = durationStr + (scheduleItem.location ?? "")
        
        if let scheduleType = scheduleItem.type {
            switch scheduleType {
            case ScheduleItemType.Session:
                type.text = "Session    "
            case ScheduleItemType.TechTalk:
                type.text = "Tech Talk    "
            case ScheduleItemType.Special:
                type.text = "Special    "
            case ScheduleItemType.Other:
                type.text = "Other    "
            default:
                type.text = ""
            }
        }
        type.isHidden = (scheduleItem.type == nil)
        
    }
}
