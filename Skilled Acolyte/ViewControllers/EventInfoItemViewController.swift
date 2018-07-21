//
//  EventInfoItemViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 21/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

class EventInfoItemViewController: UIViewController, UIWebViewDelegate {

//    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var eventInfoItem: EventInfoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = eventInfoItem.url else {
            navigationController?.popViewController(animated: true)
            return
        }
        
//        // Capitalise the first letters and set as the page title
//        infoTitle.text = eventInfoItem.name.capitalized
        
        loadUrlToWebView(url: url)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    func populate(withEventInfoItem eventInfoItem: EventInfoItem) {
        self.eventInfoItem = eventInfoItem
    }
    
    func loadUrlToWebView(url: String) {
        
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    @IBAction func btnBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // Convert this http request to a https one
        if let url = request.url,
            ((url.absoluteString.range(of: "http://")) != nil) {
            let newUrl = (url.absoluteString as String).replacingOccurrences(of: "http://", with: "https://")
            loadUrlToWebView(url: newUrl)
            return false
        }
        return true
    }
}
