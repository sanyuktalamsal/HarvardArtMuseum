//
//  ExhibitionDetailView.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import SwiftUI

struct ExhibitionDetailView: View {
    let exhibition: Exhibition
    @State private var artworks: [Artwork] = []
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Exhibition Title and Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(exhibition.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    if let description = exhibition.description {
                        Text(description)
                            .padding(.top, 4)
                            .lineLimit(3)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)

                // Loading, Error, or Artworks
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if let error = error {
                    ContentUnavailableView("Error loading artworks", systemImage: "exclamationmark.triangle")
                } else if artworks.isEmpty {
                    ContentUnavailableView("No artworks found", systemImage: "photo.on.rectangle.angled")
                } else {
                    VStack(alignment: .leading, spacing: 8) { // Remove separation between items
                        ForEach(artworks) { artwork in
                            NavigationLink(destination: ArtworkDetailView(artwork: artwork)) {
                                ArtworkGridItem(artwork: artwork)
                                    .foregroundStyle(.primary) // Ensure consistent text color
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadArtworks()
        }
    }

    private func loadArtworks() async {
        isLoading = true
        defer { isLoading = false }

        do {
            artworks = try await ArtworkService.fetchArtworksForExhibition(id: exhibition.id)
        } catch {
            self.error = error.localizedDescription
        }
    }
}

struct ArtworkGridItem: View {
    let artwork: Artwork
    @EnvironmentObject var favoritesManager: FavoritesManager

    var body: some View {
        HStack { // Use VStack for the text content and image
            ZStack(alignment: .topTrailing) { // ZStack only for the heart button over the image
                // Artwork Image
                if let imageUrl = artwork.images?.first?.baseimageurl,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100) // Image size
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                    }
                }

                // Heart Button on top of the image
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesManager.toggleFavorite(artworkId: artwork.id)
                    }
                }) {
                    Image(systemName: favoritesManager.isFavorite(artworkId: artwork.id) ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundStyle(favoritesManager.isFavorite(artworkId: artwork.id) ? .red : .gray)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(8) // Padding for the heart button from the top-right corner
            }

            // Artwork Details (Title, Artist, Date)
            VStack(alignment: .leading, spacing: 6) {
                Text(artwork.title)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    if let artist = artwork.people?.first?.name {
                        Text(artist)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if let date = artwork.dated {
                        Text("· \(date)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if let description = artwork.description {
                    Text(description)
                        .font(.caption)
                        .lineLimit(3)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 4) // Slight spacing between artworks
        .frame(height: 160) // You can adjust the height here based on your design needs
    }
}

// Artwork Detail View
struct ArtworkDetailView: View {
    let artwork: Artwork
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let firstImage = artwork.images?.first?.baseimageurl,
                   let url = URL(string: firstImage) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(artwork.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let artist = artwork.people?.first {
                        HStack {
                            Text("Artist: \(artist.name)")
                                .font(.headline)
                            
                        }
                    }
                    
                    if let date = artwork.dated {
                        Text("Date: \(date)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let medium = artwork.medium {
                        Text("Medium: \(medium)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let description = artwork.description {
                        Text("Description: \(description)")
                            .font(.headline)
                            .padding(.top)
                            .lineLimit(5)
                        
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

}
