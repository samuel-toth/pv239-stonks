//
//  PortfolioView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

struct PortfolioView: View {
    
    @State private var isSheetPresented: Bool = false

    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("To portfolio detail") {
                    PortfolioDetailView()
                        .frame(height: 50)
                }
            }

            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        isSheetPresented.toggle()

                    }) {
                        Label("Add", systemImage: "plus")
                    }
                 
                }
               
            }
            .sheet(isPresented: $isSheetPresented) {
                PortfolioAddView()
            }
            .navigationTitle("Portfolio")
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
