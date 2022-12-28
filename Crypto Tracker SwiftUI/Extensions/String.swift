//
//  String.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 28/12/22.
//

import Foundation
extension String{
    
    var removingHTMLOccurences:String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
