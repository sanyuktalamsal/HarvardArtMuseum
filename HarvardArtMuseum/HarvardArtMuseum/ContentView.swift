//
//  ContentView.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ExhibitionViewModel()
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some View {
        TabView {
            BrowseView(viewModel: viewModel)
                .environmentObject(favoritesManager)

                .tabItem {
                    Label("Browse", systemImage: "photo.artframe")
                }
            
       
            FavoritesView()
                           .environmentObject(favoritesManager)
                           .tabItem {
                               Label("Favorites", systemImage: "heart.fill")
                           }
            SearchView()
                            .environmentObject(favoritesManager)
                            .tabItem {
                                Label("Search", systemImage: "magnifyingglass")
                            }
            
            
        }
    }
}

#Preview {

}


