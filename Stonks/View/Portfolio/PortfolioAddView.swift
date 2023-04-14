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
    @State private var symbol: String = ""
    @State private var amount: Float = 0
    @State private var coinGeckoId: String?
    
    private var asset: PortfolioAsset?
    
    private var isValid: Bool {
        !name.isEmpty && !symbol.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Asset name", text: $name)
                    .onChange(of: name) { newValue in
                        name = String(newValue.prefix(10))
                    }
                    
                    TextField("Asset symbol", text: $symbol)
                    .onChange(of: name) { newValue in
                        name = String(newValue.prefix(10))
                    }
                } header: {
                    Text("Asset details")
                }
                
                Section {
                    TextField("Initial amount", value: $amount, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                        }
                } header: {
                    Text("Initial amount")
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
    }
    
    func addAsset() {
        if isValid {
            withAnimation {
                PortfolioManager.shared.addAsset(name: name, symbol: symbol, coinGeckoId: "btc", amount: amount, imageUrl: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", latestPrice: 0)
        
                dismiss()
            }
        }
    }
}

struct PortfolioAddView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioAddView()
    }
}
