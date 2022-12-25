//
//  PortfolioDataService.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 25/12/22.
//
import CoreData
import Foundation

class PortfolioDataService{
    private let container:NSPersistentContainer
    private let containerName:String = "PortfolioContainer"
    private let entityName:String = "PortfolioEntity"
    @Published var savedEntities:[PortfolioEntity] = []
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error{
                print("Error in loading core data\(error)")
            }
            self.getPortfolio()
        }
    }
    
    //MARK: PUBLIC
    
    func updatePortfolio(coin:CoinModel,amount:Double)
    {
        if let savedEntity = savedEntities.first(where: {$0.coinID == coin.id}){
            if(amount>0)
            {
                update(entity: savedEntity, amount: amount)
            }
            else
            {
                remove(entity: savedEntity)
            }
        } else
        {
            addCoin(coin: coin, amount: amount)
        }
    }
    
    //MARK: PRIVATE
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do{
            try savedEntities = container.viewContext.fetch(request)
        }
        catch let error{
            print("Error in getting portfolio entities \(error)")
        }
        
    }
    private func addCoin(coin:CoinModel,amount:Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity:PortfolioEntity,amount:Double)
    {
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity:PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    private func save(){
        do{
            try container.viewContext.save()
        } catch let error{
            print("Error saving to core Data \(error)")
        }
    }
    private func applyChanges(){
        save()
        getPortfolio()
    }
}
