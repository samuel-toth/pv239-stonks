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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(assets) { asset in
                    NavigationLink(value: asset) {
                        SearchAssetRowView(asset: asset)
                    }
                }
            }
            .navigationDestination(for: CoinGeckoAsset.self, destination: { asset in
                SearchDetailView(asset: asset)
            })
            .searchable(text: $searchText)
            .onSubmit {
                // filter here
            }
            .onChange(of: searchText) { value in
                // if value is at least 3 characters long, then filter
                if value.count >= 3 {
                    print(searchText)
                }
                fetchMostActiveAssets()
            }
            .navigationTitle("Search")
        }
        .onAppear {
            fetchMostActiveAssets()
        }
    }
    
    func fetchMostActiveAssets() {
        CoinGeckoManager.loadCoinGeckoAssets { assets in
            self.assets = assets
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
