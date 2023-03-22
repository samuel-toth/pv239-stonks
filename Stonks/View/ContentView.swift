//
//  ContentView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    /**
     @FetchRequest(
         sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
         animation: .default)
     private var items: FetchedResults<Item>
     */


    var body: some View {
        TabView {
            HomeView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            PortfolioView()
                .environment(\.managedObjectContext, viewContext)
                    .tabItem {
                        Label("Portfolio", systemImage: "bitcoinsign")
                    }
            SearchView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
