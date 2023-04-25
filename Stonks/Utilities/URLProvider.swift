//
//  URLProvider.swift
//  Stonks
//
//  Created by Samuel Tóth on 16/03/2023.
//

import Foundation
struct URLProvider {
    static func coinGeckoListUrl() -> String {
        return "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=1000&page=1&sparkline=false"
    }
    
    static func coinGeckoAssetHistory(id: String, days: Int, currency: String = "eur") -> String {
        return "https://api.coingecko.com/api/v3/coins/\(id)/market_chart?vs_currency=\(currency)&days=\(days)"
    }
}
