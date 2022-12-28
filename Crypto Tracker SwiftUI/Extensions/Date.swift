//
//  Date.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 28/12/22.
//

import Foundation

extension Date{
    
    init(coinDateString:String)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinDateString) ?? Date()
        self.init(timeInterval: 0, since: date)
        
    }
    
    private var shortFormatter:DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func convertDateToString()->String{
        return shortFormatter.string(from: self)
    }
}
