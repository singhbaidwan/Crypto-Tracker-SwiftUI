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
    @Published var isLoading:Bool = false
    @Published var sortOption:SortOption = .holding
    
    private let coinDataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    enum SortOption{
        case rank,rankReversed,holding,holdingReversed,price,priceReversed
    }
    
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
            .combineLatest(coinDataService.$allCoins,$sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map (filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
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
                guard let self = self else{return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedValue)
            }
            .store(in: &cancellables)
        
        //update market Data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map { (marketDataModel,portfolioCoins) -> [StatisticModel] in
                
                var stats:[StatisticModel] = []
                guard let data = marketDataModel else { return stats}
                
                let portfolioValue = portfolioCoins
                    .map({$0.currentHoldingsValue})
                    .reduce(0, +)
                
                let previousValue = portfolioCoins.map { coin -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                    let previousValue = currentValue/(1+percentChange)
                    return previousValue
                }
                    .reduce(0, +)
                
                let precentValue = ((portfolioValue-previousValue)/previousValue)
                
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = StatisticModel(title: "24h Volume", value: data.volume)
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
                let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: precentValue)
                
                
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
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    private func filterAndSortCoins(text:String,coins:[CoinModel],sort:SortOption)->[CoinModel]{
        var updatedCoins = filterCoins(text: text, startingCoins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    private func filterCoins(text:String,startingCoins:[CoinModel])->[CoinModel]
    {
        guard !text.isEmpty else{
            return startingCoins
        }
        let lowerCasedText = text.lowercased()
        return  startingCoins.filter { (coin) in
            return coin.name.lowercased().contains(lowerCasedText) || coin.symbol.lowercased().contains(lowerCasedText) ||
            coin.id.lowercased().contains(lowerCasedText)
        }
    }
    
    private func sortCoins(sort:SortOption,coins:inout [CoinModel]){
        switch sort{
            
        case .rank,.holding:
             coins.sort(by: {$0.rank<$1.rank})
//            return coins.sorted { coin1, coin2 in
//                return coin1.rank<coin2.rank
//            }
        case .rankReversed,.holdingReversed:
             coins.sort(by: {$0.rank>$1.rank})
        case .price:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
             coins.sort(by: { $0.currentPrice < $1.currentPrice})
        }
         
    }
    
    private func sortPortfolioCoinsIfNeeded(coins:[CoinModel])->[CoinModel]{
        // will only sort by holdings or reversed holdings if needed
        switch sortOption{
        case .holding:
            return coins.sorted(by: {$0.currentHoldingsValue>$1.currentHoldingsValue})
        case .holdingReversed:
            return coins.sorted(by: {$0.currentHoldingsValue<$1.currentHoldingsValue})
        default:
            return coins
        }
        return coins
    }
    
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    func updatePortfolio(coin:CoinModel,amount:Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
}
