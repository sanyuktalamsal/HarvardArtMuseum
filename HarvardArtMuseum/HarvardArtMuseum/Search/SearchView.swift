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
                    ContentUnavailableView("Search Artworks",
                        systemImage: "magnifyingglass",
                        description: Text("Search the Harvard Art Museum collection"))
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
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 160), spacing: 16)
                        ], spacing: 16) {
                            ForEach(artworks) { artwork in
                                ArtworkGridItem(artwork: artwork)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search artworks...")
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
