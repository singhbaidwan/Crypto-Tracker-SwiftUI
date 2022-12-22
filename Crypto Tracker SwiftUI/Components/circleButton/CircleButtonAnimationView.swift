//
//  CircleButtonAnimationView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 22/12/22.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding  var animate:Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0)
            .opacity(animate ? 0 : 1)
        // we only want to animate in one direction
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none)
           
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate:.constant(false))
    }
}
