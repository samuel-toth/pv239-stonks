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
            do {
                let assets = try JSONDecoder().decode([CoinGeckoAsset].self, from: data!)
                DispatchQueue.main.async {
                    completion(assets)
                }
            } catch {
                print("Error during data decoding: \(error)")
            }
        }
        .resume()
    }
    
    static func loadCoinGeckoAssetHistory(id: String, days: Int, currency: String?, completion:@escaping (CoinGeckoAssetHistory) -> ()) {
        guard let url = URL(string: URLProvider.coinGeckoAssetHistoryUrl(id: id, days: days)) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            do {
                let history = try JSONDecoder().decode(CoinGeckoAssetHistory.self, from: data!)
                DispatchQueue.main.async {
                    completion(history)
                }
            } catch {
                print("Error during data decoding: \(error)")
            }
        }
        .resume()
    }

    static func loadCoinGeckoAssetPrices(ids: [String], currency: String?, completion:@escaping (CoinGeckoAssetPrice) -> ()) {
                
        let ids_string: String = ids.joined(separator: ",")
        
        guard let url = URL(string: URLProvider.coinGeckoAssetsPriceUrl(ids: ids_string)) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!)
                
                print(json)
                
                if let object = json as? [Any] {
                    for item in object as! [Dictionary<String, String>] {
                        print(item["eur"])
                    }
                }
                
                
              
            } catch {
                print("Error during data decoding: \(error)")
            }
        }
        .resume()
    }
    

}
