//
//  PortfolioView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 25/12/22.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm:HomeViewModel
    @State private var selectedCoin:CoinModel? = nil
    @Binding var showPortfolioView:Bool
    @State private var quantityText:String = ""
    @State private var showCheckmark:Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading,spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil{
                    portfolioInputSection
                    }
                    
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(dismiss: $showPortfolioView)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            })
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(showPortfolioView:.constant(true))
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView{
    
    
    private var coinLogoList:some View{
        
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins){coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn)
                            {
                                selectedCoin = coin
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                selectedCoin?.id == coin.id ? Color.theme.green : .clear
                                ,lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.theme.background)
                                .shadow(color:
                                            Color.theme.accent
                                    .opacity(0.25), radius: 2, x: 4, y: 4)
                        )
                    
                    
                }
            }
            .frame(height: 130)
            .padding()
        }
    }
    
    private func getCurrentValue()->Double{
        if let quantity = Double(quantityText)
        {
            return quantity * ( selectedCoin?.currentPrice ?? 0)
        }
        return 0.0
    }
    
    private var portfolioInputSection:some View{
        VStack(spacing: 20) {
            HStack{
                Text("Current Price of\(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current Value")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .font(.headline)
    }
    
    private var trailingNavBarButton:some View{
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                (selectedCoin != nil &&
                 selectedCoin?.currentHoldings != Double(quantityText) ?? 0) ?
                1.0 : 0
            )
            
        }
        .font(.headline)
    }
    
    private func saveButtonPressed(){
        
        guard let coin = selectedCoin else {return}
        
        
        withAnimation(.easeIn)
        {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        //hiding the current keyboard
        UIApplication.shared.endEditing()
        
        //hide check mark
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            withAnimation(.easeOut)
            {
                showCheckmark = false
            }
        })
        
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
}
