//
//  ContentView.swift
//  MTG-SQLite
//
//  Created by Dylan Martin on 6/12/23.
//

import SwiftUI
import SQLite3

struct ContentView: View {
    @StateObject private var api = API()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)

                List {
                    ForEach(filteredCards) { card in
                        CardView(card: card)
                    }
                }
            }
            .navigationBarTitle("Search For Card")
            .onAppear {
                api.fetchCards { cards in
                    DispatchQueue.main.async {
                        api.cards = cards
                    }
                }
            }
        }
    }

    private var filteredCards: [Card] {
        if searchText.isEmpty {
            return api.cards
        } else {
            return api.cards.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
struct CardView: View {
    let card: Card

    var body: some View {
        Text(card.name)
            .font(.title)
            .bold()
            .padding()
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search here...", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 8)

            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 8)
            .opacity(text.isEmpty ? 0 : 1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
