//
//  SearchDetailView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI
import Charts

struct SearchDetailView: View {
    
    @State var asset: CoinGeckoAsset
    
    @State var assetHistory: CoinGeckoAssetHistory?

    @State var yScaleDomain: ClosedRange<Double> = 0...1
    
    var body: some View {
        ScrollView {
            Chart {
                ForEach(assetHistory?.chartData() ?? []) { item in
                    LineMark(
                            x: .value("Date", item.date),
                            y: .value("Price", item.price)
                    )

                }
            }
            .frame(height: 300)
            .padding(.all)
            .chartYScale(domain: yScaleDomain)
            
            HStack {
                Button(action: {
                    fetchChartData(days: 1)
                }, label: {
                    Text("1d")
                })
                Spacer()

                Button(action: {
                    fetchChartData(days: 7)
                }, label: {
                    Text("7d")
                })
                Spacer()

                Button(action: {
                    fetchChartData(days: 30)
                }, label: {
                    Text("30d")
                })
                Spacer()

                Button(action: {
                    fetchChartData(days: 183)
                }, label: {
                    Text("6m")
                })
                Spacer()

                Button(action: {
                    fetchChartData(days: 365)
                }, label: {
                    Text("1y")
                })
            }
            .padding(.all, 30)
            
            
            VStack {
                HStack {
                    Spacer()
                    Text("Price")
                        .padding(.horizontal, 30)
                }
                HStack {
                    Spacer()
                    Text("\(asset.current_price, specifier: "%.2f")")
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 30)
                }
                HStack {
                    Spacer()
                    Text("\(asset.price_change_percentage_24h ?? 0)")
                        .padding(.horizontal, 30)
                }
                
                HStack {
                    Text("Market statistics")
                        .font(.title2)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "star")
                    Text("Market capital rank")
                    Spacer()
                    Text("\(asset.market_cap_rank)")
                    
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 5)
                
                HStack {
                    Image(systemName: "star")
                    Text("Market capital")
                    Spacer()
                    Text("\(asset.market_cap)")
                    
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 5)
                
                HStack {
                    Image(systemName: "star")
                    Text("Circulating supply")
                    Spacer()
                    Text("\(asset.current_price)")
                    
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 5)
                
                HStack {
                    Image(systemName: "star")
                    Text("Max supply")
                    Spacer()
                    Text("\(asset.max_supply ?? 0)")
                    
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 5)
                
                HStack {
                    Image(systemName: "star")
                    Text("All time high")
                    Spacer()
                    Text("\(asset.ath ?? 0)")
                    
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 5)
                
                HStack {
                    Image(systemName: "star")
                    Text("All time low")
                    Spacer()
                    Text("\(asset.atl ?? 0)")
                    
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 5)
            }
            
        }
        .onAppear {
            fetchChartData(days: 30)
        }
        .navigationTitle(asset.name)
    }
    
    private func fetchChartData(days: Int) {
        CoinGeckoManager.loadCoinGeckoAssetHistory(id: asset.id, days: days, currency: nil) { ah in
            self.assetHistory = ah
            self.yScaleDomain = ah.chartData().min(by: { $0.price < $1.price })!.price...ah.chartData().max(by: { $0.price < $1.price })!.price
        }
    }
}

struct SearchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDetailView(asset: CoinGeckoAsset(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", current_price: 1.2, market_cap: 1, market_cap_rank: 1, total_volume: 200, circulating_supply: 300, total_supply: 200, max_supply: 10, ath: 10, atl: 10, price_change_24h: 20, price_change_percentage_24h: 20), assetHistory: CoinGeckoAssetHistory(prices: []))
    }
}
