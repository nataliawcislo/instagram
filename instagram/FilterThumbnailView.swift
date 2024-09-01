//
//  FilterThumbnailView.swift
//  instagram
//
//  Created by Natalia on 01.09.24.
//

import SwiftUI

struct FilterThumbnailView: View {
    let filter: Filter
    
    var body: some View {
        VStack {
            // Placeholder dla miniaturki filtra
            Image(systemName: "photo.fill") // Zastąp to rzeczywistą miniaturką filtra
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .padding(4)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(filter.displayName)
                .font(.caption)
                .foregroundColor(.primary)
                .padding(.top, 4)
        }
    }
}
