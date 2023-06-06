//
//  PortfolioAddView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

struct PortfolioAddView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var walletString: String = ""
    @State private var amount: Double = 0
    @State private var coinGeckoId: String?
    @State var assets: [CoinGeckoAsset] = []
    @State private var coinNames: [String] = []
    @State private var selectedCoinName: String = ""
    @State private var selectedCoin: CoinGeckoAsset?
    @State private var footerString: String = ""
    @State private var isWalletExpanded = false

    @AppStorage("currency") private var currency = "eur"

    
    
    private var isValid: Bool {
        !name.isEmpty && selectedCoin != nil && (walletString.isEmpty ^ (walletString.count >= 32 && walletString.count <= 64) )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Asset name", text: $name)
                        .onChange(of: name) { newValue in
                            name = String(newValue.prefix(10))
                        }
                } header: {
                    Text("Asset details")
                }
                
                Section {
                    Picker("Available Coins", selection: $selectedCoinName) {
                        ForEach(coinNames, id: \.self) { coin in
                            Text(coin).tag(coin)
                        }
                    }
                    .onChange(of: selectedCoinName) { newValue in
                        selectedCoin = assets.first(where: { $0.name == selectedCoinName
                        })
                    }
                } header: {
                    Text("Pick cryptocurrency")
                } footer: {
                    HStack {
                        Spacer()
                        Text(selectedCoin != nil ? "1 \(selectedCoin!.symbol.uppercased()) = \(selectedCoin!.current_price.formatted(.currency(code: currency)))" : "")
                    }
                }
                
                Section {
                    TextField("Initial amount", value: $amount, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        }
                        .onChange(of: amount) { _ in
                            if (selectedCoin != nil) {
                                let sum = selectedCoin!.current_price * amount
                                footerString = "\(amount) \(selectedCoin!.symbol.uppercased()) =  \(sum.formatted(.currency(code: currency)))"
                            }
                        }
                } header: {
                    Text("Initial amount")
                } footer: {
                    HStack {
                        Spacer()
                        Text(footerString)
                    }
                }
                
                DisclosureGroup("Wallet number", isExpanded: $isWalletExpanded) {
                    TextField("Asset number (32-64 characters)", text: $walletString)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addAsset()
                    }
                    .disabled(!isValid)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add to portfolio")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            fetchAssets()
        }
    }
    
    func addAsset() {
        if isValid {
            withAnimation {
                PortfolioManager.shared.addAsset(name: name, symbol: selectedCoin!.symbol, coinGeckoId: selectedCoin!.id, amount: amount, imageUrl: selectedCoin!.image, latestPrice: selectedCoin!.current_price, walletString: !walletString.isEmpty ? walletString : nil)
                
                dismiss()
            }
        }
    }
    
    func fetchAssets() {
        CoinGeckoManager.loadCoinGeckoAssets(currency: currency) { assets in
            self.assets = assets
            coinNames = assets.map {
                $0.name
            }
        }
    }
}

struct PortfolioAddView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioAddView()
    }
}

extension Bool {
    static func ^(lhs: Bool, rhs: Bool) -> Bool {
        return lhs != rhs
    }
}
