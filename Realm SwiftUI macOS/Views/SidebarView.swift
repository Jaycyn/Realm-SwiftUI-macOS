//
//  SidebarView.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/7/24.
//

import RealmSwift
import SwiftUI

//the sidebar view, duh. Shows a list of added items

struct SidebarView: View {
    @ObservedRealmObject var itemGroup: ItemGroup
    @Binding var selectedItem: Item?

    var body: some View {
        Text("Sidebar")

        List(selection: $selectedItem) {
            let _ = print("refreshing list")

            ForEach(itemGroup.items) { item in
                NavigationLink(item.itemName, value: item)
                    .contextMenu {
                        Button("Remove From List", role: .destructive) {
                            if let idx = itemGroup.items.firstIndex(of: item) {
                                $itemGroup.items.remove(at: idx)
                                if item == selectedItem {
                                    selectedItem = nil
                                }
                            }
                        }

                        Button("Delete Object", role: .destructive) {
                            let thawedItem = item.thaw()!
                            let realm = thawedItem.realm!.thaw()
                            try! realm.write {
                                realm.delete(thawedItem)
                            }
                            if thawedItem == selectedItem {
                                selectedItem = nil
                            }
                            //need to add group title to group - maybe some kind of random thing like the
                            //  item name "groove group" "cool group" etc.
                        }
                    }
            }
            .onMove(perform: $itemGroup.items.move)
        }
        .onDeleteCommand {
            if
                let sel = selectedItem,
                let idx = itemGroup.items.firstIndex(of: sel) {
                    $itemGroup.items.remove(at: idx)
                }
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 300, max: 400)
        .onAppear {
            Task { @MainActor in
                try await Task.sleep(for: .seconds(0.05))
                //selectedNavItem = .home
            }
        }

        HStack {
            Button(action: {
                let _ = print("adding item")
                let randomName = "\(randomAdjectives.randomElement()!) \(randomNouns.randomElement()!)"
                let app: RealmSwift.App? = RealmSwift.App(id: kAppId)
                let user = app?.currentUser
                let item = Item(itemName: randomName, isFavorite: true, ownerId: user!.id)
                $itemGroup.items.append(item)
            }, label: {
                Label("Add Item", systemImage: "plus.circle")
            })
            .padding()
            
            Button("FileURL") { //just a test button to show where path to the local file when an item is selected
                if let item = selectedItem {
                    if let r = item.realm {
                        if let path = r.configuration.fileURL {
                            print(path)
                        } else {
                            print("no path found")
                        }
                    } else {
                        print("no realm found")
                    }
                } else {
                    print("no item selected")
                }
            }
        }
    }
}

#Preview {
    let realm = ItemGroup.previewRealm
    let itemGroup = realm.objects(ItemGroup.self)
    //let item = itemGroup.first!.items.first!
    return SidebarView(itemGroup: itemGroup.first!, selectedItem: .constant(nil) )
}
