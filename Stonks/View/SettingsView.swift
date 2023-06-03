//
//  SettingsView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

enum Currency: String, CaseIterable, Identifiable, Equatable {
    case eur, usd, czk
    var id: Self { self }
}

struct SettingsView: View {
    
    @State private var selectedCurrency: Currency = (Currency(rawValue: UserDefaults.standard.string(forKey: "currency") ?? "eur") ?? .eur)

    
    var body: some View {
        NavigationStack {
            List {
                Picker("Select currency", selection: $selectedCurrency) {
                    ForEach(Currency.allCases) { currency in
                        Text(currency.rawValue.uppercased())
                    }
                }
            }
            .onChange(of: selectedCurrency) { _ in
                print(selectedCurrency)
                UserDefaults.standard.set(selectedCurrency.rawValue, forKey: "currency")
                PortfolioManager.shared.updateAllAssetsPricesFromApi(currency: selectedCurrency.rawValue)

            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
