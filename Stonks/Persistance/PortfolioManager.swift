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
    
    func addAsset(){
        save()
    }

    func deleteAsset(asset: PortfolioAsset){
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
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
