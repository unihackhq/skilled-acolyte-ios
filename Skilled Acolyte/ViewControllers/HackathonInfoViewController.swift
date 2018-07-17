//
//  HackathonInfoViewController.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 17/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

class HackathonInfoViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUrlToWebView(url: "https://handbook.readthedocs.io/en/latest/")
    }
    
    func loadUrlToWebView(url: String) {
        
        let url = URL(string: url)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
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
