//
//  CoinDetailDataService.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 27/12/22.
//
import SwiftUI
import Combine
class CoinDetailDataService{
    @Published var coinDetails:CoinDetailModel? = nil
    var coinDetailSubscription:AnyCancellable?
    let coin:CoinModel
    init(coin:CoinModel){
        self.coin = coin
        getCoinDetails()
    }
     func getCoinDetails(){
         guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else{return}
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] returnedCoinDetail in
                self?.coinDetails = returnedCoinDetail
                self?.coinDetailSubscription?.cancel()
            })

    }
}
