//
//  CoinGeckoAsset.swift
//  Stonks
//
//  Created by Samuel Tóth on 16/03/2023.
//

import Foundation

struct CoinGeckoAsset: Identifiable, Codable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let market_cap: Double
    let market_cap_rank: Int
    let total_volume: Double?
    let circulating_supply: Double?
    let total_supply: Double?
    let max_supply: Double?
    let ath: Double?
    let atl: Double?
    let price_change_24h: Double?
    let price_change_percentage_24h: Double?
}
