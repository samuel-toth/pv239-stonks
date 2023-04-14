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
                Text(asset.symbol ?? "")
                    .font(.footnote)
                    .lineLimit(1)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack {
                Text("\(asset.amount, specifier: "%.2f")")
                    .font(.title2)
                    .foregroundColor(.accentColor)
           
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
