//
//  ExhibitionViewModel.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import Foundation


enum BrowseLoadingState{
    case idle
    case loading
    case success(exhibits: [Exhibition])
    case error(message: String)
}

@MainActor
class ExhibitionViewModel: ObservableObject {
    @Published var state: BrowseLoadingState = .idle
    
    func fetchAllExhibits() async {
        do {
            state = .loading
            let exhibits = try await ArtworkService.fetchAllExhibitions()
            print("Fetched \(exhibits.count) exhibitions")
            state = .success(exhibits: exhibits)
        } catch let error {
            print("Error fetching exhibitions: \(error)")
            state = .error(message: "Unable to fetch all exhibitions")
        }
    }
}
