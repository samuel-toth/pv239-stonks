//
//  HomeView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isSheetPresented: Bool = false
    @AppStorage("currency") private var currency = "eur"
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PortfolioAsset.name, ascending: true)], predicate: NSPredicate(format: "isFavourite == YES"))
    private var favouriteAssets: FetchedResults<PortfolioAsset>
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    HStack {
                        Spacer()
                        Text("Your balance")
                            .font(.title2)
                    }
                    .padding([.horizontal, .top], 30)
                    
                    HStack {
                        Spacer()
                        Text(PortfolioManager.shared.getAllAssetsWorthPrice().formatted(.currency(code: currency)))
                            .font(.system(size: 50))
                            .foregroundColor(Color("lightGreen"))
                    }
                    .padding(.horizontal, 30)
                    
                    HStack {
                        Spacer()
                        Text("in \(PortfolioManager.shared.getAssetsCount()) assets")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 30)
                }
                
                if (favouriteAssets.isEmpty) {
                    Text("You did not marked any asset as favourite.")
                        .padding(10)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    
                    List(favouriteAssets) { asset in
                        NavigationLink(value: asset) {
                            PortfolioAssetRowView(asset: asset)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationDestination(for: PortfolioAsset.self, destination: { asset in
                PortfolioDetailView(asset: asset)
                    .environment(\.managedObjectContext, viewContext)
            })
            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        isSheetPresented.toggle()
                    }) {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                SettingsView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
