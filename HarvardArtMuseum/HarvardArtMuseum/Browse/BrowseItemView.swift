//
//  BrowseItemView.swift
//  HarvardArtMuseum
//
//  Created by Sanyukta Lamsal on 1/19/25.
//
import SwiftUI

struct BrowseItemView: View {
    let exhibit: Exhibition
    var body: some View {
        VStack {
            if let imageUrl = exhibit.primaryimageurl,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                        .frame(height: 126)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 180)
                }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(exhibit.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    HStack {
                        Text(exhibit.formattedBeginDate)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        Text("-")
                        Text(exhibit.formattedEndDate ?? "-")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                }
                if let shortDesc = exhibit.description {
                    Text(shortDesc)
                        .lineLimit(3)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    
}
