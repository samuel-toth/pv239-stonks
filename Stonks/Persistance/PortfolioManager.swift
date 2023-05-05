//
//  PortfolioManager.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import Foundation
import CoreData
import CodableCSV

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

    func updateAllAssetsPricesFromApi() {
        let assets = getAssets()
        let ids = assets.map { $0.coinGeckoId! }
        
        CoinGeckoManager.loadCoinGeckoAssetPrices(ids: ids, currency: "eur") { latestPrices in
            for asset in assets {
                let latestPrice = latestPrices.first(where: { $0.id == asset.coinGeckoId! })?.price
                if latestPrice != nil {
                    self.updateAssetPrice(asset: asset, price: latestPrice!)
                }
            }
        }
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

    func getAllAssetsWorthPrice() -> Double {
        let assets = getAssets()
        var total = 0.0
        for asset in assets {
            total += asset.amount * asset.latestPrice
        }
        return total
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

    func getAssetsCount() -> Int {
        let request: NSFetchRequest<PortfolioAsset> = PortfolioAsset.fetchRequest()
        do {
            let result = try viewContext.count(for: request)
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

    func getAssets() -> [PortfolioAsset] {
        let request: NSFetchRequest<PortfolioAsset> = PortfolioAsset.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PortfolioAsset.name, ascending: true)]

        do {
            let result = try viewContext.fetch(request)
            return result
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getAllPortfolioAssetsHistoryRecords() -> [PortfolioAssetHistoryRecord] {
        let request: NSFetchRequest<PortfolioAssetHistoryRecord> = PortfolioAssetHistoryRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PortfolioAssetHistoryRecord.createdAt, ascending: true)]
        do {
            let result = try viewContext.fetch(request)
            return result
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func exportData() -> ExportImportFile {
        // TODO: this needs refactoring, extract to export class
        let allAssetHistoryRecords = getAllPortfolioAssetsHistoryRecords()
//        let propertyNames = Mirror(reflecting: PortfolioAssetHistoryRecord()).children.compactMap { $0.label }
        var myRows = [
            ["asset", "change", "transaction date"]
        ]
        do {
            for item in allAssetHistoryRecords {
                // TODO: some nil remained in my db, wipe needed
                let assetName = item.asset?.name
                if assetName == nil {
                    continue
                } else {
                    myRows.append([assetName!, String(item.value), item.createdAt!.dateToFormattedDatetime()])
                }
            }
            let string = try CSVWriter.encode(rows: myRows, into: String.self)
            return ExportImportFile(initialContent: string)
        } catch {
            fatalError("Unexpected error encoding CSV: \(error)")
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
        newAsset.isFavourite = true
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
