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
    @IBOutlet weak var itemContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func populate(with scheduleItem: ScheduleItem) {
        
        var startTimeStr = ""
        
        if let startDate = scheduleItem.startDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HHa"
            startTimeStr = formatter.string(from: startDate) + " "
        }
                
        itemTitle.text = scheduleItem.name
        itemSubtitle.text = startTimeStr + (scheduleItem.location ?? "")
        itemContent.text = scheduleItem.scheduleDescription
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
}
