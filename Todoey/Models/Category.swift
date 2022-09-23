//
//  Category.swift
//  Todoey
//
//  Created by Uriel Hernandez Gonzalez on 22/09/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name = ""
    @Persisted var items: List<Item>
}
