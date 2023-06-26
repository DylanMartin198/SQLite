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

    let options = ["Name", "Number", "Rarity", "Types"]

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
                            Text("Filter By...")
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
        let searchOption = options[selectedOption]

        if searchText.isEmpty {
            return api.cards.sorted(by: { compareCards($0, $1, by: searchOption) })
        } else {
            return api.cards.filter { $0.name!.localizedCaseInsensitiveContains(searchText) }
                            .sorted(by: { compareCards($0, $1, by: searchOption) })
        }
    }
    
    private func compareCards(_ card1: Card, _ card2: Card, by option: String) -> Bool {
        switch option {
        case "Name":
            return card1.name!.localizedCaseInsensitiveCompare(card2.name!) == .orderedAscending
        case "Number":
            return card1.number!.localizedCaseInsensitiveCompare(card2.number!) == .orderedAscending
        case "Rarity":
            return compareRarity(card1.rarity!, card2.rarity!)
        case "Types":
            return card1.types!.localizedCaseInsensitiveCompare(card2.types!) == .orderedAscending
        default:
            return true
        }
    }

    private func compareRarity(_ rarity1: String, _ rarity2: String) -> Bool {
        let rarityOrder = ["Rare", "Uncommon", "Common"]
        
        guard let index1 = rarityOrder.firstIndex(of: rarity1),
              let index2 = rarityOrder.firstIndex(of: rarity2) else {
            return true
        }
        
        return index1 < index2
    }
}

struct CardView: View {
    let card: Card

    var body: some View {
        Text(card.name!)
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
