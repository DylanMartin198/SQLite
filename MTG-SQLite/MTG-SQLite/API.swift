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
    
    func fetchCards(completion: @escaping ([Card]) -> Void) {
        isLoading = true
        
        let bundlePath = Bundle.main.bundleURL.absoluteString
        guard let db = try? Connection(bundlePath + "AllPrintings.sqlite") else {
            completion([])
            return
        }
//        db.trace({ print($0) })
        let table = Table("cards")
        // where setCode == "mom" - picker/drop down with column names and when they tap search you filter all cards by that colum and search that columns text
        // print all columns in a table
        
        
        var name = Expression<String>("name")
        let id = Expression<String>("uuid")

        do {
            let query = table.select(name, id)
            
//            let result = try db.prepare(query.limit(1000))
            let result = try db.prepare(table.limit(1000))

            for row in result {
                let cardName = row[name]
                let cardID = row[id]
                let card = Card(name: cardName, id: cardID)
                cards.append(card)
            }
                
//            for row in try db.prepare("SELECT name, uuid FROM cards LIMIT 1000") {
//                let cardName = row[0] as! String?
//                let cardID = row[1] as! String?
//                let card = Card(name: cardName!, id: cardID!)
//                cards.append(card)
//            }
        } catch {
            print("Error querying database: \(error)")
            completion([])
        }
        
        isLoading = false
    }
}
