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
    @State private var numberSearchText = ""
    @State private var selectedTypes: Set<String> = []
    @State private var selectedRarities: Set<String> = []
    @State private var shouldShowResults = false
    @State private var isSubmitButtonPressed = false
    
    private let typeOptions = ["Creature", "Artifact", "Enchantment", "Instant", "Planeswalker", "Conspiracy", "Land"]
    private let rarityOptions = ["mythic", "rare", "uncommon", "common"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) { // Increase the spacing between items
                VStack(spacing: 8) {
                    TextField("Search by name...", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    
                    TextField("Search by number...", text: $numberSearchText)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 8)
                
                HStack {
                    Text("Types:")
                        .font(.headline)
                        .padding(.trailing, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(typeOptions, id: \.self) { option in
                                Button(action: {
                                    if selectedTypes.contains(option) {
                                        selectedTypes.remove(option)
                                    } else {
                                        selectedTypes.insert(option)
                                    }
                                }) {
                                    BoxView(label: option, isSelected: selectedTypes.contains(option))
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Rarity:")
                        .font(.headline)
                        .padding(.trailing, 8)
                    
                    ForEach(rarityOptions, id: \.self) { option in
                        Button(action: {
                            if selectedRarities.contains(option) {
                                selectedRarities.remove(option)
                            } else {
                                selectedRarities.insert(option)
                            }
                        }) {
                            BoxView(label: option, isSelected: selectedRarities.contains(option))
                        }
                    }
                }
                
                Button(action: {
                    isSubmitButtonPressed = true
                    shouldShowResults = true
                    
                    let selectedTypeString = selectedTypes.joined(separator: ",")
                    let selectedRarityString = selectedRarities.joined(separator: ",")
                    
                    api.fetchCards(nameSearchText: searchText, numberSearchText: numberSearchText, selectedType: selectedTypeString, selectedRarity: selectedRarityString) { cards in
                        DispatchQueue.main.async {
                            api.cards = cards
                        }
                    }
                }) {
                    Text("Search")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                if shouldShowResults {
                    if api.cards.isEmpty {
                        Text("No results found")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        NavigationLink(
                            destination: ResultView(cards: api.cards, onBack: {
                                shouldShowResults = false
                            }),
                            isActive: $shouldShowResults,
                            label: { EmptyView() }
                        )
                        .hidden()
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("Search For Card")
            .padding(.top, 20) // Adjust the top padding to reduce the gap
        }
    }
}

struct BoxView: View {
    let label: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(isSelected ? .blue : .gray)
                .frame(width: 20, height: 20)
            
            Text(label)
                .font(.caption)
        }
        .padding(.trailing, 8)
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
