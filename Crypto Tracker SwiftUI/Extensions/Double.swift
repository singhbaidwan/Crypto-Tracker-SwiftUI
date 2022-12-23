//
//  Double.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 22/12/22.
//

import Foundation

extension Double{
    /// Converts  a double value of currency to 2-6 decimal places
    /// ```
    /// converts 1234.56 to 1,234.56
    /// ```
    private var currencyFormatter:NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    
    /// Converts  a double value of currency as a string to 2-6 decimal places
    /// ```
    /// converts 1234.56 to "1,234.56"
    /// ```
    func asCurrencyWith6Decimals()->String{
        let nsNumber = NSNumber(value: self)
        return currencyFormatter.string(from: nsNumber) ?? "0.00"
    }
    
    /// Converts  a double value to string with two decimal places
    /// ```
    /// converts 1234.5645 to "1,234.56"
    /// ```
    func asNumberString()->String{
        return String(format: "%.2f", self)
    }
    
    /// Converts  a double value to string with two decimal places with a percentage sign
    /// ```
    /// converts 1234.5645 to "1,234.56%"
    /// ```
    func asPercentageString()->String{
        return asNumberString()+"%"
    }
}
