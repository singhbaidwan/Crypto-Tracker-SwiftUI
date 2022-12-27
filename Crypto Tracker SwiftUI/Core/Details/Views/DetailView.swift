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
    let coin:CoinModel
    @StateObject var vm:DetailViewModel
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ZStack{
                Text(coin.name)
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
