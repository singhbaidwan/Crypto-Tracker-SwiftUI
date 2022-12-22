//
//  HomeView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 22/12/22.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio:Bool = false
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea(.all)
            VStack{
               homeHeader
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .ignoresSafeArea()
    }
}
extension HomeView{
    private var homeHeader:some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none,value: UUID())
                .background(
                CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" :"Live Prices")
                .font(.footnote)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: UUID())
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(.init(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring())
                    {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
}
