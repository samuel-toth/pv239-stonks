//
//  CoinGeckoAssetHistory.swift
//  Stonks
//
//  Created by Samuel Tóth on 22/03/2023.
//

import Foundation

struct CoinGeckoAssetHistory: Codable, Hashable {
    var prices: [[Double]]

    // create method that parse the prices array into ChartData
    func chartData() -> [ChartData] {
        return prices.map { ChartData(date: Date(timeIntervalSince1970: $0[0] / 1000), price: $0[1]) }
    }

}

struct ChartData: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}
