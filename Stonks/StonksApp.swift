//
//  StonksApp.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

@main
struct StonksApp: App {
    
    let persistenceController = PersistenceController.shared
    @AppStorage("currency") private var currency = "eur"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear() {
                    PortfolioManager.shared.updateAllAssetsPricesFromApi(currency: currency)
                }
        }
    }
}
