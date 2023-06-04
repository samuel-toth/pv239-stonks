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
    @State private var isExportPresented = false
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("Choose currency")
                Spacer()
                Picker("Select currency", selection: $selectedCurrency) {
                    ForEach(Currency.allCases) { currency in
                        Text(currency.rawValue.uppercased())
                    }
                }
            }
            .padding([.horizontal], 30)
            
            
            HStack {
                Text("Export portfolio")
                Spacer()
                Button(action: {
                    isExportPresented.toggle()
                }) {
                    Image(systemName: "tray.and.arrow.up")
                }.buttonStyle(.bordered)
            }
            .padding([.horizontal], 30)
            
            Spacer()
            .onChange(of: selectedCurrency) { _ in
                print(selectedCurrency)
                UserDefaults.standard.set(selectedCurrency.rawValue, forKey: "currency")
                PortfolioManager.shared.updateAllAssetsPricesFromApi(currency: selectedCurrency.rawValue)
                
            }
            .fileExporter(
                isPresented: $isExportPresented,
                document: CSVExporter.exportHistoryRecords(records: PortfolioManager.shared.getAllPortfolioAssetsHistoryRecords()),
                contentType: .commaSeparatedText,
                defaultFilename: "Export \(getCurrentDateTime().string(from: Date.now))"
            ) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print("Export error: \(error)")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func getCurrentDateTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY HH-mm-ss"
        return formatter
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
