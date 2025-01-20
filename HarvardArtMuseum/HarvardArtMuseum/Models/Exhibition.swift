//
//  Exhibition.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//

import Foundation

struct Exhibition: Identifiable, Codable{
    var id: Int
    var exhibitionid: Int
    var title: String
    var records: String?
    var begindate: String
    var enddate: String?
    var description: String?
    var shortdescription: String?
    var primaryimageurl: String?
//    let venues: [Venue]?
    let images: [ExhibitionImage]?
//    let videos: [Video]?
//    let publications: [Publication]?
//    
    var formattedBeginDate: String {
            formatDate(from: begindate)
        }
        
        var formattedEndDate: String? {
            guard let enddate = enddate else { return nil }
            return formatDate(from: enddate)
        }
        
        // Helper function to format a date string
        private func formatDate(from dateString: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd" // Input format
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d" // Output format (e.g., Jan 12)
            
            if let date = inputFormatter.date(from: dateString) {
                return outputFormatter.string(from: date)
            }
            
            return dateString // Return the original string if parsing fails
        }
    }
    

