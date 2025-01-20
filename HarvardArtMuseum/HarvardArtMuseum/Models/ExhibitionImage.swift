//
//  ExhibitionImage.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import Foundation

struct ExhibitionImage: Codable {
    let date: String?
    let copyright: String?
    let imageid: Int
    let idsid: Int
    let format: String?
    let caption: String?
    let description: String?
    let technique: String?
    let renditionnumber: String?
    let displayorder: Int
    let baseimageurl: String
    let alttext: String?
    let width: Int
    let iiifbaseuri: String?
    let height: Int
}
