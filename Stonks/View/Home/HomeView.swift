//
//  HomeView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isSheetPresented: Bool = false
    @Environment(\.managedObjectContext) private var viewContext


    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PortfolioAsset.name, ascending: true)], predicate: NSPredicate(format: "isFavourite == YES"))
    private var favouriteAssets: FetchedResults<PortfolioAsset>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    HStack {
                        Spacer()
                        Text("Your balance")
                            .font(.title2)
                    }
                    .padding([.horizontal, .top], 30)
                    
                    HStack {
                        Spacer()
                        Text(PortfolioManager.shared.getAllAssetsWorthPrice().formatted(.currency(code: "EUR")))
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
                Divider()
                
                HStack {
                    Text("Favourites")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                if (favouriteAssets.isEmpty) {
                    Text("You did not marked any asset as favourite.")
                        .padding(10)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    ForEach(favouriteAssets) { asset in
                        NavigationLink(value: asset) {
                            PortfolioAssetRowView(asset: asset)
                        }
                        .padding(20)

                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.separator), lineWidth: 1))
                        .padding(.horizontal, 20)

                    }
                   
                    
                }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {
                            // TODO: Import
                        }) {
                            Label("Import", systemImage: "tray.and.arrow.down")
                        }
                        Button(action: {
                            // TODO: Export

                        }) {
                            Label("Export", systemImage: "tray.and.arrow.up")
                        }
                    }
                    label: {
                        Label("add", systemImage: "ellipsis")
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                SettingsView()
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
