//
//  UIApplication.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 24/12/22.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
