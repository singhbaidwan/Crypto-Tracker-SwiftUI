//
//  HapticManager.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 26/12/22.
//

import Foundation
import SwiftUI

class HapticManager{
    static private let generator = UINotificationFeedbackGenerator()
    static func notification(type:UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
