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
    private var currencyFormatter6:NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    private var currencyFormatter2:NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith2Decimals()->String{
        let nsNumber = NSNumber(value: self)
        return currencyFormatter2.string(from: nsNumber) ?? "0.00"
    }
    /// Converts  a double value of currency as a string to 2-6 decimal places
    /// ```
    /// converts 1234.56 to "1,234.56"
    /// ```
    func asCurrencyWith6Decimals()->String{
        let nsNumber = NSNumber(value: self)
        return currencyFormatter6.string(from: nsNumber) ?? "0.00"
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
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }

}
