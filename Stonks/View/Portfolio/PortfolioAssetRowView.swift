//
//  PortfolioAssetRowView.swift
//  Stonks
//
//  Created by Samuel Tóth on 14/04/2023.
//

import SwiftUI

struct PortfolioAssetRowView: View {
    
    @State private var asset: PortfolioAsset
    
    
    init(asset: PortfolioAsset) {
        self.asset = asset
    }
    
    var body: some View {
        HStack {
            
            AsyncImage(
                url: URL(string: asset.imageUrl ?? ""),
                content: { image in
                    image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 40, maxHeight: 40)
            },
                placeholder: {
                    ProgressView()
                        .frame(maxWidth: 40, maxHeight: 40)

            })
            
            VStack (alignment: HorizontalAlignment.leading) {
                Text(asset.name ?? "")
                    .font(.body)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                Text(asset.coinGeckoId ?? "")
                    .font(.footnote)
                    .lineLimit(1)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(Double(asset.amount * asset.latestPrice).formatted(.currency(code: "EUR")))
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Text("\(asset.amount, specifier: "%.2f \(asset.symbol?.uppercased() ?? "")")")
                    .font(.subheadline)
                    .foregroundColor(.gray)

            }
        }
    }
}

struct PortfolioAssetRowView_Previews: PreviewProvider {
    static var previews: some View {
        let asset = PortfolioManager.shared.createTestData()

        PortfolioAssetRowView(asset: asset)
    }
}
