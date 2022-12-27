//
//  DetailViewModel.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 27/12/22.
//
import SwiftUI
import Combine

class DetailViewModel:ObservableObject{
    private let coinDetailService:CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    init(coin:CoinModel) {
        coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    private func addSubscribers(){
        coinDetailService.$coinDetails
            .sink { returnedCoinDetails in
                print("GOT THe coin details")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
}
