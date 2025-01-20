//
//  ExhibitionDetailView.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import SwiftUI


// Exhibition Detail View
struct ExhibitionDetailView: View {
    let exhibition: Exhibition
    @State private var artworks: [Artwork] = []
    @State private var isLoading = false
    @State private var error: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Exhibition Header
                if let imageUrl = exhibition.primaryimageurl,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 200)
                            .clipped()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(exhibition.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(exhibition.begindate) - \(exhibition.enddate)")
                        .foregroundStyle(.secondary)
                    
                    if let description = exhibition.description {
                        Text(description)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal)
                
                // Artworks Grid
                Text("Featured Artworks")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.top)
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 200)
                } else if let error = error {
                    ContentUnavailableView("Error loading artworks", systemImage: "exclamationmark.triangle")
                } else if artworks.isEmpty {
                    ContentUnavailableView("No artworks found", systemImage: "photo.on.rectangle.angled")
                } else {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 160), spacing: 16)
                    ], spacing: 16) {
                        ForEach(artworks) { artwork in
                            NavigationLink(destination: ArtworkDetailView(artwork: artwork)) {
                                ArtworkGridItem(artwork: artwork)
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

// Artwork Grid Item
struct ArtworkGridItem: View {
    let artwork: Artwork
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
    
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(artwork.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                    
                    if let artist = artwork.people?.first?.name {
                        Text(artist)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    if let date = artwork.dated {
                        Text(date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 2)
            
            // Heart button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    favoritesManager.toggleFavorite(artworkId: artwork.id)
                }
            }) {
                Image(systemName: favoritesManager.isFavorite(artworkId: artwork.id) ? "heart.fill" : "heart")
                    .font(.system(size: 15))
                    .foregroundStyle(favoritesManager.isFavorite(artworkId: artwork.id) ? .red : .gray)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(8)
        }
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
                            Text(artist.name)
                                .font(.headline)
                            if let role = artist.role {
                                Text("(\(role))")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    if let date = artwork.dated {
                        Text(date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let medium = artwork.medium {
                        Text(medium)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let description = artwork.description {
                        Text("About")
                            .font(.headline)
                            .padding(.top)
                        
                        Text(description)
                            .font(.body)
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
