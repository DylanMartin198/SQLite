//
//  API.swift
//  MTG-SQLite
//
//  Created by Dylan Martin on 6/14/23.
//

import Foundation
import SQLite

class API: ObservableObject {
    @Published var cards: [Card] = []
    @Published var isLoading: Bool = false
    
    func fetchCards(nameSearchText: String, numberSearchText: String, setCodeText: String, selectedType: String, selectedRarity: String, completion: @escaping ([Card]) -> Void) {
        isLoading = true
        
        let bundlePath = Bundle.main.bundleURL.path
        guard let db = try? Connection(bundlePath + "/AllPrintings.sqlite") else {
            completion([])
            return
        }
        
        let table = Table("cards")
        let name = Expression<String>("name")
        let id = Expression<String>("uuid")
        let rarity = Expression<String>("rarity")
        let number = Expression<String>("number")
        let types = Expression<String>("types")
        let setCode = Expression<String>("setCode")

        var query = table.limit(1000)
        
        if !nameSearchText.isEmpty {
            query = query.filter(name.like("%\(nameSearchText)%"))
        }
        
        if !numberSearchText.isEmpty {
            query = query.filter(number.like("%\(numberSearchText)%"))
        }
        
        if !setCodeText.isEmpty {
            query = query.filter(setCode.like("%\(setCodeText)%"))
        }
        
        if !selectedType.isEmpty {
            query = query.filter(types.like("%\(selectedType)%"))
        }
        
        if !selectedRarity.isEmpty {
            query = query.filter(rarity.like("%\(selectedRarity)%"))
        }

        do {
            let result = try db.prepare(query)
            var cards: [Card] = []
            
            for row in result {
                let cardName = row[name]
                let cardID = row[id]
                let cardRarity = row[rarity]
                let cardNumber = row[number]
                let cardTypes = row[types]
                let setCode = row[setCode]
                let card = Card(name: cardName, id: cardID, rarity: cardRarity, number: cardNumber, types: cardTypes, setCode: setCode)
                cards.append(card)
            }
            
            completion(cards)
        } catch {
            print("Error querying database: \(error)")
            completion([])
        }
        
        isLoading = false
    }
    
    private func column(for searchOption: String) -> Expression<String> {
        let name = Expression<String>("name")
        let number = Expression<String>("number")
        let rarity = Expression<String>("rarity")
        let types = Expression<String>("types")
        let setCode = Expression<String>("setCode")

        switch searchOption {
        case "Name":
            return name
        case "Number":
            return number
        case "Rarity":
            return rarity
        case "Types":
            return types
        case "setCode":
            return setCode
        default:
            return name
        }
    }
}
