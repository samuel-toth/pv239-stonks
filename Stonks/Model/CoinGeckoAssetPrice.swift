//
//  CoinGeckoAssetPrice.swift
//  Stonks
//
//  Created by Samuel Tóth on 04/05/2023.
//

import Foundation

struct CoinGeckoAssetPrice: Codable, Hashable {
    var id: String
    var price: Double
}
