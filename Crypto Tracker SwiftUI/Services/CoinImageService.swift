//
//  CoinImageService.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 23/12/22.
//

import Foundation
import SwiftUI
import Combine
class CoinImageService{
    @Published var image:UIImage? = nil
    private var imageSubscription : AnyCancellable?
    private var coin:CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName:String
    
    init(coin:CoinModel)
    {
        self.coin = coin
        imageName = String(coin.id)
        getCoinImage()
    }
    
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
//            print("Image successfully placed from file Manager")
        }
        else
        {
            downloadCoinImage()
//            print("Image downloaded successfully ")
        }
    }
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image)
        else{return}
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data)->UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] returnedImage in
                guard let self = self, let returnedImage = returnedImage else {return }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: returnedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
