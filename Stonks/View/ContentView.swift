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
