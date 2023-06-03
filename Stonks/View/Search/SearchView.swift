//
//  SearchView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText: String = ""
    @State var assets: [CoinGeckoAsset] = []
    @State private var filteredAssets: [CoinGeckoAsset] = []
    @AppStorage("currency") private var currency = "eur"

    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredAssets) { asset in
                    NavigationLink(value: asset) {
                        SearchAssetRowView(asset: asset)
                    }
                }
            }
            .navigationDestination(for: CoinGeckoAsset.self, destination: { asset in
                SearchDetailView(asset: asset)
            })
            .searchable(text: $searchText)
            .onChange(of: searchText) { value in
                if value.count >= 1 {
                    filterAssets()
                } else {
                    filteredAssets = assets
                }
            }
            .navigationTitle("Search")
        }
        .onAppear {
            fetchMostActiveAssets()
        }
    }
    
    func fetchMostActiveAssets() {
        CoinGeckoManager.loadCoinGeckoAssets(currency: currency) { assets in
            self.assets = assets
            self.filteredAssets = assets
        }
    }
    
    func filterAssets() {
        filteredAssets = assets.filter { asset in
            asset.name.lowercased().contains(searchText.lowercased()) || asset.symbol.lowercased().contains(searchText.lowercased())
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
