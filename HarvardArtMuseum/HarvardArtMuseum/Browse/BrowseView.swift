//
//  BrowseView.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import SwiftUI

struct BrowseView: View {
    @StateObject var viewModel = ExhibitionViewModel()
    @State private var searchText = ""
    
    var filteredExhibitions: [Exhibition] {
        guard !searchText.isEmpty else {
            // If search is empty, return all exhibitions
            if case .success(let exhibits) = viewModel.state {
                return exhibits
            }
            return []
        }
        
        // If we have search text and exhibitions, filter them
        if case .success(let exhibits) = viewModel.state {
            return exhibits.filter { exhibit in
                let searchQuery = searchText.lowercased()
                return exhibit.title.lowercased().contains(searchQuery) ||
                (exhibit.shortdescription?.lowercased().contains(searchQuery) ?? false) ||
                (exhibit.description?.lowercased().contains(searchQuery) ?? false)
            }
        }
        return []
    }
    
    var body: some View {
        NavigationStack {
            List {
                switch viewModel.state {
                case .idle:
                    idleView
                case .loading:
                    loadingView
                case .success:
                    if filteredExhibitions.isEmpty {
                        ContentUnavailableView("No matches found", systemImage: "magnifyingglass")
                    } else {
                        exhibitsView(exhibits: filteredExhibitions)
                    }
                case .error(let message):
                    errorView(message: "An error occurred")
                }
            }
            .navigationTitle("Browse")
            .searchable(text: $searchText, prompt: "Search for an exhibition")
            .task {
                await viewModel.fetchAllExhibits()
            }
        }
    }
    
    
    @ViewBuilder
    private func exhibitsView(exhibits: [Exhibition]) -> some View {
        
        ForEach(exhibits) { exhibit in
            ZStack{
                BrowseItemView(exhibit: exhibit)
                    .contentShape(Rectangle())
                NavigationLink(destination: ExhibitionDetailView(exhibition: exhibit)) {
                    EmptyView()
                }
                .buttonStyle(PlainButtonStyle()) // Removes the arrow while keeping navigation functional
                .opacity(0)
            }
        }
    }



    @ViewBuilder
    private var idleView: some View {
        ContentUnavailableView("No exhibits shown", systemImage: "x.circle")
    }
    
    @ViewBuilder
    private var loadingView: some View {
        ContentUnavailableView("Loading...", systemImage: "circle.hexagonpath")
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        ContentUnavailableView(message, systemImage: "exclamationmark.circle")
    }
}
#Preview {
    BrowseView()
}
