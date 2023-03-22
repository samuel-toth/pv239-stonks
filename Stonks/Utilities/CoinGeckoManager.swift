//
//  CoinGeckoManager.swift
//  Stonks
//
//  Created by Samuel Tóth on 16/03/2023.
//

import Foundation

class CoinGeckoManager {
    
    static func loadCoinGeckoAssets(completion:@escaping ([CoinGeckoAsset]) -> ()) {
        guard let url = URL(string: URLProvider.coinGeckoListUrl()) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let assets = try! JSONDecoder().decode([CoinGeckoAsset].self, from: data!)            
            DispatchQueue.main.async {
                completion(assets)
            }
        }
        .resume()
    }
    
    static func loadCoinGeckoAssetHistory(id: String, days: Int, currency: String?, completion:@escaping (CoinGeckoAssetHistory) -> ()) {
        guard let url = URL(string: URLProvider.coinGeckoAssetHistory(id: id, days: days)) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let history = try! JSONDecoder().decode(CoinGeckoAssetHistory.self, from: data!)
            DispatchQueue.main.async {
                completion(history)
            }
        }
        .resume()
    }
    

}
