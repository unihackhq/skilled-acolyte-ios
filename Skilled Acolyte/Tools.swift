//
//  Tools.swift
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 19/7/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

import UIKit

struct Tools {
    
    func iso(fromDate date: Date?) -> String? {
        guard let date = date else { return nil }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: date)
    }
    
    func date(fromIso iso: String?) -> Date? {
        guard let iso = iso else { return nil }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // Convert from full ISO format
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let dateAttempt = formatter.date(from: iso) {
            return dateAttempt
        }
        
        // Convert from partial ISO format
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: iso)
    }
    
    func uiColor(fromHex hex: String?) -> UIColor? {
        guard let hex = hex else { return nil }
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
