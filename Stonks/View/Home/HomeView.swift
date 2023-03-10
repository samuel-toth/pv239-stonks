//
//  HomeView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isSheetPresented: Bool = false

    
    var body: some View {
        NavigationStack {
            List {
                Text("Test 1")
                Text("Test 2")
                Text("Test 3")
            }
            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        isSheetPresented.toggle()
                    }) {
                        Label("Settings", systemImage: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {
                            // TODO: Import
                        }) {
                            Label("Import", systemImage: "tray.and.arrow.down")
                        }
                        Button(action: {
                            // TODO: Export

                        }) {
                            Label("Export", systemImage: "tray.and.arrow.up")
                        }
                    }
                    label: {
                        Label("add", systemImage: "ellipsis")
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                SettingsView()
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
