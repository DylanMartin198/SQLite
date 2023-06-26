//
//  Card.swift
//  MTG-SQLite
//
//  Created by Dylan Martin on 6/14/23.
//

import Foundation

struct Card: Codable, Identifiable {
    let name: String?
    let id: String?
    let rarity: String?
    let number: String?
    let types: String?
//    let image: String
}
