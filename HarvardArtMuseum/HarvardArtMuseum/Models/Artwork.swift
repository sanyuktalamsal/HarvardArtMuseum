//
//  Artwork.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import Foundation

struct Artwork: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String?
    let dated: String?
    let images: [ArtworkImage]?
    let people: [Artist]?
    let division: String?
    let medium: String?
    
    struct ArtworkImage: Codable {
        let baseimageurl: String?
        let caption: String?
    }
    
    struct Artist: Codable {
        let name: String
        let role: String?
    }
    
}

struct Person: Codable, Identifiable {
    let id: Int
    let name: String
    let displayname: String?
    let gender: String?
    let culture: String?
    let birthplace: String?
    let deathplace: String?
    let displaydate: String?
    let imageurl: String?
}

struct Gallery: Codable, Identifiable {
    let id: Int
    let name: String
    let floor: Int?
    let theme: String?
    let description: String?
}


