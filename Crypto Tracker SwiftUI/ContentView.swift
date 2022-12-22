//
//  ContentView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 22/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Color.theme.secondaryText
                .ignoresSafeArea(.all)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
