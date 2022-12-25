//
//  HomeViewModel.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 23/12/22.
//

import Foundation
import SwiftUI
import Combine
class HomeViewModel:ObservableObject{
    @Published var allCoins = [CoinModel]()
    @Published var portfolioCoins = [CoinModel]()
    @Published var searchText:String = ""
    @Published var statistics:[StatisticModel] = []
    
    
    private let coinDataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    init(){
        addSubscribers()
    }
    func addSubscribers(){
        
        //        dataService.$allCoins
        //            .sink { [weak self] returnedCoins in
        //                self?.allCoins = returnedCoins
        //            }
        //            .store(in: &cancellables)
        // this function handles the query as well as updates all the coins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text,startingCoins)->[CoinModel] in
                guard !text.isEmpty else{
                    return startingCoins
                }
                let lowerCasedText = text.lowercased()
                return  startingCoins.filter { (coin) in
                    return coin.name.lowercased().contains(lowerCasedText) || coin.symbol.lowercased().contains(lowerCasedText) ||
                    coin.id.lowercased().contains(lowerCasedText)
                }
            }
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map { (marketDataModel) -> [StatisticModel] in
                
                var stats:[StatisticModel] = []
                guard let data = marketDataModel else { return stats}
                
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: "24h Volume", value: data.volume)
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
                let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
                
                stats.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])
                return stats
            }
            .sink { [weak self]returnedData in
                self?.statistics = returnedData
            }
            .store(in: &cancellables)
        
        
        
        // Updates Portfolio data
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map{ (coinModel,portfolioEntities)->[CoinModel] in
                
                coinModel
                    .compactMap { coin -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {return nil}
                        
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedValue in
                
                self?.portfolioCoins =  returnedValue
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin:CoinModel,amount:Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
}
