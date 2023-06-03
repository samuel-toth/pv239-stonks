//
//  PortfolioView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isSheetPresented: Bool = false
    @AppStorage("currency") private var currency = "eur"
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \PortfolioAsset.name, ascending: true)])
    private var assets: FetchedResults<PortfolioAsset>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(assets) { asset in
                    NavigationLink(value: asset) {
                        PortfolioAssetRowView(asset: asset)
                    }
                }
                .onDelete(perform: deleteAsset)
                .listRowBackground(Color(UIColor.secondarySystemGroupedBackground).opacity(0.8))
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
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                PortfolioAddView()
            }
            .navigationTitle("Portfolio")
            .refreshable {
                PortfolioManager.shared.updateAllAssetsPricesFromApi(currency: currency)
            }
        }
    }
    
    private func deleteAsset(offsets: IndexSet) {
        withAnimation {
            offsets.map { assets[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
