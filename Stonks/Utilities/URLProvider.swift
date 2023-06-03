//
//  URLProvider.swift
//  Stonks
//
//  Created by Samuel Tóth on 16/03/2023.
//

import Foundation
struct URLProvider {
    static func coinGeckoListUrl(currency: String = "eur") -> String {
        return "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(currency)&order=market_cap_desc&per_page=1000&page=1&sparkline=false"
    }
    
    static func coinGeckoAssetHistoryUrl(id: String, days: Int, currency: String = "eur") -> String {
        return "https://api.coingecko.com/api/v3/coins/\(id)/market_chart?vs_currency=\(currency)&days=\(days)"
    }
    
    static func coinGeckoAssetsPriceUrl(ids: String, currency: String = "eur") -> String {
        return "https://api.coingecko.com/api/v3/simple/price?ids=\(ids)&vs_currencies=\(currency)"
    }
}
