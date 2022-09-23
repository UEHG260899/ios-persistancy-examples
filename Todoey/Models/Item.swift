//
//  Item.swift
//  Todoey
//
//  Created by Uriel Hernandez Gonzalez on 22/09/22.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title = ""
    @Persisted var isDone = false
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<Category>
}
