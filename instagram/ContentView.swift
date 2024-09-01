//
//  ContentView.swift
//  instagram
//
//  Created by Natalia on 01.09.24.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        VStack {
            if let image = UIImage(named: "example.png") {
                PhotoEditView(image: image)
            } else {
                Text("Image not found")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
