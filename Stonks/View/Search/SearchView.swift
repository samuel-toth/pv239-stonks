//
//  SearchView.swift
//  Stonks
//
//  Created by Samuel Tóth on 10/03/2023.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("To search detail") {
                    SearchDetailView()
                }
            }
            .searchable(text: $searchText)
            .onSubmit {
                // filter here
            }
            .navigationTitle("Search")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
