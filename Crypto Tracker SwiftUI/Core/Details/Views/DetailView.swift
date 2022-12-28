//
//  DetailView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 26/12/22.
//


/*
 To prevent the loading of view in case we have nil coin we use DetailLoadingView . We will only call Detail view when we are confirm that it is not nil
 */
import SwiftUI

struct DetailLoadingView:View{
    @Binding var coin:CoinModel?
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }
    var body: some View {
        ZStack{
            if let coin = coin{
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var vm:DetailViewModel
    private let columns:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing:CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView{
            VStack{
                
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    
                    overviewTitle
                    Divider()
                    
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    
                    additionalGrid
                }
                .padding()
                
            }
        }
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}


extension DetailView{
    
    
    private var navigationBarTrailingItems:some View{
        
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
        
    }
    
    private var overviewTitle: some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var additionalTitle:some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
        
    }
    
    private var overviewGrid: some View{
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            
            ForEach(vm.overviewStatistics){ stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid:some View{
        
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: []) {
            
            ForEach(vm.additionalStatistics){ stat in
                StatisticView(stat: stat)
            }
        }
    }
    
}
