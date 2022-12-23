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
    
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    func addSubscribers(){
        dataService.$allCoins
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
