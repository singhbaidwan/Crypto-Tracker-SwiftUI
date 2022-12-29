//
//  HomeView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 22/12/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm:HomeViewModel
    @State private var showPortfolio:Bool = false //animate right
    @State private var showPortfolioView:Bool = false // new sheet
    @State private var selectedCoin:CoinModel? = nil
    @State private var showDetailView:Bool = false
    @State private var showSettingView:Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView(showPortfolioView: $showPortfolioView)
                        .environmentObject(vm)
                }
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
                    ZStack(alignment: .top){
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty{
                         portFolioEmpty
                        }
                    }
                    addListToView(data: vm.portfolioCoins, show: true)
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingView) {
                SettingsView(dismiss: $showSettingView)
            }
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin), isActive: $showDetailView, label: {
                EmptyView()
            })
        
        )
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
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    }
                    else
                    {
                        showSettingView.toggle()
                    }
                }
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
    
    private var portFolioEmpty:some View{
        
            Text("You havnt added any coins to your portfolio yet. Click the + button to get Started !")
                .font(.callout)
                .foregroundColor(Color.theme.accent)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(50)
    }
    @ViewBuilder
    func addListToView(data:[CoinModel],show:Bool) -> some View{
        List{
            ForEach(data){ coin in
                
                CoinRowView(coin: coin, showHoldingsColumn: show)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin:CoinModel)
    {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    var listHeaderView:some View{
        HStack{
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                    .rotationEffect(.init(degrees: (vm.sortOption == .rank ? 0 : 180)))
            }
            .onTapGesture {
                withAnimation(.default)
                {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity( (vm.sortOption == .holding || vm.sortOption == .holdingReversed) ? 1 : 0)
                        .rotationEffect(.init(degrees: (vm.sortOption == .holding ? 0 : 180)))
                }
                .onTapGesture {
                    withAnimation(.default)
                    {
                        vm.sortOption = vm.sortOption == .holding ? .holdingReversed : .holding
                    }
                }
            }
            Spacer()
            HStack(spacing:4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                    .rotationEffect(.init(degrees: (vm.sortOption == .price ? 0 : 180)))
            }
            .onTapGesture {
                withAnimation(.default)
                {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            Button {
                withAnimation(.linear(duration: 2))
                {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(.init(degrees: vm.isLoading ? 360 : 0))
            
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
        .padding(.leading,35)
    }
}
