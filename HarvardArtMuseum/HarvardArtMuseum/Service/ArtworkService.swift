//
//  ArtworkService.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import Foundation

struct ArtworkService{
    
    
    static func fetchAllExhibitions() async throws -> [Exhibition]{
        let API_KEY = "2c1cf28a-ca0a-467b-a058-6a1b234800f1"
        let urlString = "https://api.harvardartmuseums.org/exhibition?apikey=\(API_KEY)&hasimage=1"
        guard let url = URL(string: urlString) else{
            fatalError("Invalid URL")}
        let (data, _) = try await URLSession.shared.data(from:url)
        
        let decoder = JSONDecoder()

        let response = try decoder.decode(ExhibitionResponse.self, from:data)
        
        return response.records
    }
    

        static func fetchArtworksForExhibition(id: Int) async throws -> [Artwork] {
            let API_KEY = "2c1cf28a-ca0a-467b-a058-6a1b234800f1"
            let urlString = "https://api.harvardartmuseums.org/object?apikey=\(API_KEY)&exhibition=\(id)&hasimage=1"
            
            guard let url = URL(string: urlString) else {
                fatalError("Invalid URL")}
            
            
            let (data, _) = try await URLSession.shared.data(from:url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ArtworkResponse.self, from: data)
            return response.records
        }
    
    static func fetchArtwork(id: Int) async throws -> Artwork? {
            let API_KEY = "2c1cf28a-ca0a-467b-a058-6a1b234800f1"
            let urlString = "https://api.harvardartmuseums.org/object/\(id)?apikey=\(API_KEY)&hasimage=1"
            
            guard let url = URL(string: urlString) else {
                fatalError("Invalid URL")}
            
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            return try decoder.decode(Artwork.self, from: data)
        }
    
    static func searchArtworks(query: String) async throws -> [Artwork] {
            let API_KEY = "2c1cf28a-ca0a-467b-a058-6a1b234800f1"
            let urlString = "https://api.harvardartmuseums.org/object?apikey=\(API_KEY)&q=\(query)&hasimage=1"
            
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: urlString.replacingOccurrences(of: "q=\(query)", with: "q=\(encodedQuery)")) else {
                fatalError("Invalid URL")}

            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ArtworkResponse.self, from: data)
            return response.records
        }
    
   
    
    

    struct ExhibitionResponse: Codable {
        let records: [Exhibition]
    }
    
    struct ArtworkResponse: Codable {
        let records: [Artwork]
    }
}

