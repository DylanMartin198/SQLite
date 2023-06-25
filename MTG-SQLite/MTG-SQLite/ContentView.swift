//
//  ContentView.swift
//  MTG-SQLite
//
//  Created by Dylan Martin on 6/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var api = API()
    @State private var searchText = ""
    @State private var isPickerVisible = false
    @State private var selectedOption = 0

    let options = ["Card Name", "Card Number", "Rarity", "Types"]

    var body: some View {
            NavigationView {
                VStack {
                    HStack {
                        TextField("Search here...", text: $searchText, onEditingChanged: { isEditing in
                            if isEditing {
                                isPickerVisible = true
                            }
                        })
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .padding(.horizontal, 8)

                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                        .opacity(searchText.isEmpty ? 0 : 1)
                    }
                    .padding()
                    if isPickerVisible {
                        HStack {
                            Text("Sort by...")
                                .foregroundColor(.black)
                                .bold()
                                .padding()
                            Picker(selection: $selectedOption, label: Text("Search By")) {
                                ForEach(0..<4) { index in
                                    Text(options[index])
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                        }
                        .padding()
                        .onDisappear {
                            isPickerVisible = false
                        }
                    }

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
