//
//  SearchAssetRowView.swift
//  Stonks
//
//  Created by Samuel Tóth on 16/03/2023.
//

import SwiftUI

struct SearchAssetRowView: View {
    
    @State private var asset: CoinGeckoAsset
    
    
    init(asset: CoinGeckoAsset) {
        self.asset = asset
    }
    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string:asset.image),
                content: { image in
                    image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 40, maxHeight: 40)
            },
            placeholder: {
                ProgressView()
            })
            
            
            VStack (alignment: HorizontalAlignment.leading) {
                Text(asset.name)
                    .font(Font.system(.title2, design: .default))
                    .lineLimit(2)
                Text(asset.symbol)
                    .font(Font.system(.subheadline))
                    .lineLimit(1)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack {
                Text(asset.current_price.formatted(.currency(code: "EUR")))
                    .font(.title3)
           
            }
        }
    }
}

struct SearchAssetRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchAssetRowView(asset: CoinGeckoAsset(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", current_price: 1.2, market_cap: 1, market_cap_rank: 1, total_volume: 200, circulating_supply: 300, total_supply: 200, max_supply: 10, ath: 10, atl: 10, price_change_24h: 20, price_change_percentage_24h: 20))
    }
}
