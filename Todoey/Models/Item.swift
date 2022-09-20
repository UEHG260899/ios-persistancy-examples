//
//  Item.swift
//  Todoey
//
//  Created by Uriel Hernandez Gonzalez on 19/09/22.
//

import Foundation

struct Item: Codable {
    let title: String
    var isDone: Bool = false
}
