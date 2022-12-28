//
//  DetailViewModel.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 27/12/22.
//
import SwiftUI
import Combine

class DetailViewModel:ObservableObject{
    
    @Published var overviewStatistics:[StatisticModel] = []
    @Published var additionalStatistics:[StatisticModel] = []
    @Published var coin:CoinModel
    @Published var coinDescription:String? = nil
    @Published var websiteUrl:String? = nil
    @Published var redditUrl:String? = nil
    
    
    
    private let coinDetailService:CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin:CoinModel) {
        self.coin = coin
        coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails.sink { [weak self](returnedCoinDetails) in
            self?.coinDescription = returnedCoinDetails?.readableDescriptions
            self?.websiteUrl = returnedCoinDetails?.links?.homepage?.first
            self?.redditUrl = returnedCoinDetails?.links?.subredditURL
            
        }
        .store(in: &cancellables)
        
    }
    
    private func mapDataToStatistics(coinDetailModel:CoinDetailModel?,
                                     coinModel:CoinModel)->(overview:[StatisticModel],additional:[StatisticModel]){
        
        let overviewArray = createOverviewArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        let additionalArrays = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overviewArray,additionalArrays)
    }
    
    private func createOverviewArray(coinDetailModel:CoinDetailModel?,
                                     coinModel:CoinModel)->[StatisticModel]{
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$"+(coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$"+(coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray:[StatisticModel] = [
            priceStat,marketCapStat,rankStat,volumeStat
        ]
        return overviewArray
    }
    private func createAdditionalArray(coinDetailModel:CoinDetailModel?,
                                       coinModel:CoinModel)->[StatisticModel]{
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentageChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentageChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArrays:[StatisticModel] = [
            highStat,lowStat,priceChangeStat,marketCapChangeStat,blockStat,hashingStat
        ]
        return additionalArrays
    }
    
}
