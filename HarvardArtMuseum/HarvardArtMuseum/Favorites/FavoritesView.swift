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
                    ContentUnavailableView("No matches found", systemImage: "magnifyingglass")
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredArtworks) { artwork in
                                HStack(alignment: .top) {
                                    // Artwork Image
                                    if let imageUrl = artwork.images?.first?.baseimageurl,
                                       let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(8)
                                                .clipped()
                                        } placeholder: {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 100, height: 100)
                                        }
                                    }
                                    
                                    // Artwork Details
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(artwork.title)
                                            .font(.headline)
                                            .lineLimit(2)
                                        
                                        if let people = artwork.people, !people.isEmpty || artwork.dated != nil {
                                            HStack {
                                                if let people = artwork.people, !people.isEmpty {
                                                    Text(people.map { $0.name }.joined(separator: ", "))
                                                        .font(.caption)
                                                        .foregroundStyle(.secondary)
                                                }
                                                
                                                if let date = artwork.dated {
                                                    Text(", \(date)") // Adding a comma between artist and date
                                                        .font(.caption)
                                                        .foregroundStyle(.secondary)
                                                }
                                            }
                                        }
                                        
                                        if let description = artwork.description {
                                            Text(description)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure text is aligned left
                                }
                                .padding([.horizontal, .vertical], 8)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .searchable(text: $searchText, prompt: "Search for an artwork")
        }
        .task {
            await loadFavoriteArtworks()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Text("You have no favorited artworks.")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Button(action: {
                // Action when button is pressed
            }) {
                NavigationLink(destination: BrowseView()) {
                    Text("Browse Artworks")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
            }
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
