//
//  HomepageViewController.swift
//  Skilled Acolyte
//
//  Created by Sophia Huynh on 17/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {

    @IBOutlet weak var lblEventName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let student = Configuration.CurrentStudent else { return }
        
        // Load the student's events
        Networking.shared.getStudentEvents(byStudentId: student.id) { (error, events) in
            
            if let _ = error {
                // TODO: handle error
            } else {
                Configuration.StudentsEvents = events
                if events.count > 1 {
                    // TODO: this student has more than one events. show some way for them to switch between events
                } else if events.count == 0 {
                    // this student has no events :(
                    return
                }
                
                let firstEvent = events.first
                Configuration.CurrentEvent = firstEvent
                self.lblEventName.text = firstEvent?.name
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
