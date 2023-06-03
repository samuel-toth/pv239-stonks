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
    @State private var showingExporter = false
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
//                        Button(action: {
//                            // TODO: Import
//                        }) {
//                            Label("Import", systemImage: "tray.and.arrow.down")
//                        }
                        Button(action: {
                            showingExporter.toggle()
                        }) {
                            Label("Stonks export", systemImage: "tray.and.arrow.up")
                        }
                    }
                label: {
                    Label("add", systemImage: "ellipsis")
                }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                SettingsView()
                    .presentationDetents([.medium])
            }
            .fileExporter(
                isPresented: $showingExporter,
                document: PortfolioManager.shared.exportData(),
                contentType: .commaSeparatedText,
                defaultFilename: "Export \(getCurrentDateTime().string(from: Date.now))"
            ) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print("Export error: \(error)")
                }
            }
            .navigationTitle("Home")
        }
    }
    
    private func getCurrentDateTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY HH-mm-ss"
        return formatter
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
