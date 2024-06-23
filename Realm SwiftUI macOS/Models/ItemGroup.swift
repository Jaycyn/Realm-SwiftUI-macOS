//
//  ItemGroup.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/7/24.
//

import RealmSwift

class ItemGroup: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var groupName = ""
    @Persisted var items = RealmSwift.List<Item>()
    @Persisted var ownerId = ""
}

//this extensions adds the stuff to make the Preview work.
//  Preview needs static data for display so this provides it
extension ItemGroup {
    static let itemGroup = ItemGroup(value: ["ownerId": "previewRealm"])

    static var previewRealm: Realm {
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            let realmObjects = realm.objects(ItemGroup.self)
            if realmObjects.count == 1 {
                return realm
            } else {
                try realm.write {
                    realm.add(itemGroup)
                    itemGroup.items.append(objectsIn: [Item.item1, Item.item2, Item.item3])
                }
                return realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}
