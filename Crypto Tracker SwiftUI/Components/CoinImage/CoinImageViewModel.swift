//
//  CoinImageViewModel.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 23/12/22.
//

import Foundation
import SwiftUI
import Combine
class CoinImageViewModel:ObservableObject{
    
    @Published var image:UIImage? = nil
    @Published var isLoading:Bool = false
    
    private let coin:CoinModel
    private let dataService:CoinImageService
    private var cancellabels = Set<AnyCancellable>()
    
    init(coin:CoinModel){
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.isLoading = true
        addSubscribers()
    }
    private func addSubscribers(){
        dataService.$image
            .sink { [weak self](_) in
                self?.isLoading = false
            } receiveValue: { [weak self](returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellabels)
    }
}

