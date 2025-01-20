//
//  SearchView.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//
import SwiftUI

// SearchView
struct SearchView: View {
    @State private var searchText = ""
    @State private var artworks: [Artwork] = []
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    Text("")
                } else if isLoading {
                    ProgressView()
                } else if let error = error {
                    ContentUnavailableView("Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error))
                } else if artworks.isEmpty {
                    ContentUnavailableView("No Results",
                        systemImage: "magnifyingglass",
                        description: Text("Try searching for something else"))
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Iterate over each artwork and display the image, title, and medium
                            ForEach(artworks) { artwork in
                                HStack(spacing: 16) {
                                    // Artwork Image (small image)
                                    if let imageUrl = artwork.images?.first?.baseimageurl,
                                       let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 8)) // Rounded corners for image
                                        } placeholder: {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 60, height: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                    
                                    // Artwork Details (Title and Medium)
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(artwork.title)
                                            .font(.headline)
                                            .lineLimit(2)
                                            .foregroundStyle(.primary)
                                        
                                        // Artwork Medium (type of artwork)
                                        if let medium = artwork.medium {
                                            Text(medium)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure alignment to the left
                                }
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                        
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search for an artwork")
        }
        .onChange(of: searchText) { oldValue, newValue in
            // Debounce search to avoid too many API calls
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
                await performSearch()
            }
        }
    }

    private func performSearch() async {
        guard !searchText.isEmpty else {
            artworks = []
            return
        }

        isLoading = true
        error = nil

        do {
            artworks = try await ArtworkService.searchArtworks(query: searchText)
        } catch {
            self.error = "Failed to search artworks: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

#Preview {
    SearchView()
}
