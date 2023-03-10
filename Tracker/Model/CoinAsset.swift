//
//  CoinAsset.swift
//  Tracker
//
//  Created by Samuel Tóth on 10/03/2023.
//

import Foundation
struct CoinAsset {
    var id = UUID()
    var symbol: String
    var imageUrl: String
    var marketCap: Double
    var marketRank: Double
    var priceChange: Double
    var allTimeHigh: Double
    var circulatingSupply: Double
    var currentPrice: Double
    
    init(symbol: String, imageUrl: String, marketCap: Double, marketRank: Double, priceChange: Double, allTimeHigh: Double, circulatingSupply: Double, currentPrice: Double) {
        self.symbol = symbol
        self.imageUrl = imageUrl
        self.marketCap = marketCap
        self.marketRank = marketRank
        self.priceChange = priceChange
        self.allTimeHigh = allTimeHigh
        self.circulatingSupply = circulatingSupply
        self.currentPrice = currentPrice
    }
}
