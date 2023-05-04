//
//  PortfolioManager.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import Foundation
import CoreData

class PortfolioManager {
    
    static let shared = PortfolioManager()
    
    private var viewContext = PersistenceController.shared.container.viewContext
    
    func addAsset(name: String, symbol: String, coinGeckoId: String, amount: Double, imageUrl: String?, latestPrice: Double?) {
        let newAsset = PortfolioAsset(context: viewContext)
        newAsset.id = UUID()
        newAsset.name = name
        newAsset.symbol = symbol
        newAsset.coinGeckoId = coinGeckoId
        newAsset.amount = amount
        
        let newHistoryRecord = PortfolioAssetHistoryRecord(context: viewContext)
        newHistoryRecord.id = UUID()
        newHistoryRecord.createdAt = Date()
        newHistoryRecord.value = amount
        newHistoryRecord.asset = newAsset
        
        if imageUrl != nil {
            newAsset.imageUrl = imageUrl!
        }
        
        if latestPrice != nil {
            newAsset.latestPrice = latestPrice!
        }
        
        save()
    }
    
    func updateAssetPrice(asset: PortfolioAsset, price: Double) {
        asset.latestPrice = price
        save()
    }
    
    func updateAssetName(asset: PortfolioAsset, name: String) {
        asset.name = name
        save()
    }
    
    func updateAssetAmount(asset: PortfolioAsset, value: Double) {
        asset.amount += value
        
        let newHistoryRecord = PortfolioAssetHistoryRecord(context: viewContext)
        newHistoryRecord.id = UUID()
        newHistoryRecord.createdAt = Date()
        newHistoryRecord.value = value
        newHistoryRecord.asset = asset
        save()
    }
    
    func getAssetHistoryRecords(id: UUID) -> [PortfolioAssetHistoryRecord] {
        
        let request: NSFetchRequest<PortfolioAssetHistoryRecord> = PortfolioAssetHistoryRecord.fetchRequest()
        request.predicate = NSPredicate(format: "asset.id == %@", id as CVarArg)

        do {
            let result = try viewContext.fetch(request)
            return result
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func deleteAsset(asset: PortfolioAsset) {
        viewContext.delete(asset)
        save()
    }

    func getAsset(id: UUID) -> PortfolioAsset? {
        let request: NSFetchRequest<PortfolioAsset> = PortfolioAsset.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let result = try viewContext.fetch(request)
            return result.first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func toggleFavourite(asset: PortfolioAsset) {
        asset.isFavourite.toggle()
        
        save()
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func createTestData() -> PortfolioAsset {
        let newAsset = PortfolioAsset(context: viewContext)
        newAsset.id = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        newAsset.name = "Test Counter"
        newAsset.amount = 0
        newAsset.symbol = "BTC"
        newAsset.imageUrl = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"


        do {
            try viewContext.save()
            return newAsset
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
