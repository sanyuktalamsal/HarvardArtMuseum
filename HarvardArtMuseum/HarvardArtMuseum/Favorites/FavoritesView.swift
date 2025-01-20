//
//  FavoritesView.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import SwiftUI
struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var favoriteArtworks: [Artwork] = []
    @State private var isLoading = false
    @State private var searchText = ""
    
    var filteredArtworks: [Artwork] {
        guard !searchText.isEmpty else {
            return favoriteArtworks
        }
        
        return favoriteArtworks.filter { artwork in
            let searchQuery = searchText.lowercased()
            return artwork.title.lowercased().contains(searchQuery) ||
                   (artwork.people?.first?.name.lowercased().contains(searchQuery) ?? false) ||
                   (artwork.description?.lowercased().contains(searchQuery) ?? false)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if favoriteArtworks.isEmpty {
                    emptyStateView
                } else if filteredArtworks.isEmpty {
                    ContentUnavailableView("No matches found",
                        systemImage: "magnifyingglass")
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 160), spacing: 16)
                        ], spacing: 16) {
                            ForEach(filteredArtworks) { artwork in
                                ArtworkGridItem(artwork: artwork)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .searchable(text: $searchText, prompt: "Search favorites...")
        }
        .task {
            await loadFavoriteArtworks()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Favorite Artworks")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start exploring artworks and add them to your favorites!")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func loadFavoriteArtworks() async {
        isLoading = true
        var loadedArtworks: [Artwork] = []
        
        for artworkId in favoritesManager.favoriteArtworks {
            do {
                if let artwork = try await ArtworkService.fetchArtwork(id: artworkId) {
                    loadedArtworks.append(artwork)
                }
            } catch {
                print("Error loading artwork: \(error)")
            }
        }
        
        favoriteArtworks = loadedArtworks
        isLoading = false
    }
}
#Preview {
    FavoritesView()
}
