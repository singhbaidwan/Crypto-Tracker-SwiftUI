//
//  HomeView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 22/12/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm:HomeViewModel
    @State private var showPortfolio:Bool = false
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea(.all)
            VStack{
                homeHeader
                HomeStatasView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                listHeaderView
                
                if !showPortfolio{
                    addListToView(data: vm.allCoins, show: false)
                        .transition(.move(edge: .leading))
                }
                else
                {
                    addListToView(data: vm.portfolioCoins, show: true)
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
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
    
    
    @ViewBuilder
    func addListToView(data:[CoinModel],show:Bool) -> some View{
        List{
            ForEach(data){ coin in
                CoinRowView(coin: coin, showHoldingsColumn: show)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    var listHeaderView:some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holdings")
            }
            Spacer()
            Text("Price")
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
        .padding(.leading,35)
    }
}
