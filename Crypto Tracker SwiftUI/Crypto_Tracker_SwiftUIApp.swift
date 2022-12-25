//
//  Crypto_Tracker_SwiftUIApp.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 22/12/22.
//

import SwiftUI

@main
struct Crypto_Tracker_SwiftUIApp: App {
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(homeViewModel)
        }
    }
}
