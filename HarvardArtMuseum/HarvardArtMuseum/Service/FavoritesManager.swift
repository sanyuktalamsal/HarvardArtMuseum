//
//  FavoritesManager.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteArtworks: Set<Int> = []  // ids of favorited artworks
    
    func toggleFavorite(artworkId: Int) {
        if favoriteArtworks.contains(artworkId) {
            favoriteArtworks.remove(artworkId)
        } else {
            favoriteArtworks.insert(artworkId)
        }
    }
    
    func isFavorite(artworkId: Int) -> Bool {
        favoriteArtworks.contains(artworkId)
    }
}
