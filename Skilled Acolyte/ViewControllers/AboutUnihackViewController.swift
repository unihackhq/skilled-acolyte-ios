//
//  AboutUnihackViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 26/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

class AboutUnihackViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomItem: UIView! // this should be the lowest item inside the scrollview
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: bottomItem.frame.origin.y+bottomItem.frame.size.height+40)
        view.sendSubview(toBack: scrollView);
    }
    
    @IBAction func btnBackTapped() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMelbourneTapped() {
        
        UIApplication.shared.open(URL(string : "https://www.eventbrite.com.au/e/unihack-melbourne-2018-registration-45721295626")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnSydneyTapped() {
        
        UIApplication.shared.open(URL(string : "https://www.eventbrite.com.au/e/unihack-2018-sydney-hackathon-tickets-45706344908")!, options: [:], completionHandler: nil)
    }
}
