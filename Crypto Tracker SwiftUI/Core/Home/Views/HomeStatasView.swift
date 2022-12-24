//
//  HomeStatasView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 24/12/22.
//

import SwiftUI

struct HomeStatasView: View {
    
    @EnvironmentObject private var vm:HomeViewModel
    @Binding var showPortfolio:Bool
    
    var body: some View {
        HStack{
            ForEach(vm.statistics){stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width/3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,alignment: showPortfolio ? .trailing : .leading)
    }
    
}

struct HomeStatasView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatasView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
