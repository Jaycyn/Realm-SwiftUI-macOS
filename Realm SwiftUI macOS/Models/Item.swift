//
//  Item.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/7/24.
//

import RealmSwift

class Item: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var itemName = ""
    @Persisted var isFavorite = false
    @Persisted var ownerId = ""
    @Persisted var test = ""
    
    /// The backlink to the `ItemGroup` this item is a part of.
    @Persisted(originProperty: "items") var group: LinkingObjects<ItemGroup>

    convenience init(itemName: String, isFavorite: Bool, ownerId: String) {
        self.init()
        self.itemName = itemName
        self.isFavorite = isFavorite
        self.ownerId = ownerId
    }
}

//static data for preview
extension Item {
    static let item1 = Item(value: ["itemName": "fluffy coasters", "isFavorite": false, "ownerId": "previewRealm"])
    static let item2 = Item(value: ["itemName": "sudden cinder block", "isFavorite": true, "ownerId": "previewRealm"])
    static let item3 = Item(value: ["itemName": "classy mouse pad", "isFavorite": false, "ownerId": "previewRealm"])
}
