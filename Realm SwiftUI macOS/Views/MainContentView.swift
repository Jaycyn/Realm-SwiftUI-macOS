//
//  ContentView.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/4/24.
//

import RealmSwift
import SwiftUI

//this is the main content view where items can be added and removed (contextual click on one to remove)
//  as well as clicked on to show it in the detail view
//this is called directly fron the ContentView if we are working with a local only realm.
//  and called as the last step in setting up the sync'ing process

struct MainContentView: View {
    @ObservedResults(ItemGroup.self) var itemGroups
    @State private var selectedItem: Item?

    var body: some View {
        NavigationSplitView {
            if let itemGroup = itemGroups.first {
                let _ = print("showing first item group")
                SidebarView(itemGroup: itemGroup, selectedItem: $selectedItem)

            } else {
                ProgressView().onAppear {
                    let _ = print("ContentView: no group found, adding it")

                    let app = App(id: kAppId)
                    if let user = app.currentUser { //see if we are syncing; if so, add an ItemGroup with users id
                        let itemGroup = ItemGroup(value: ["ownerId":user.id])
                        $itemGroups.append( itemGroup )
                    } else { //local only? just add an item group
                        let itemGroup = ItemGroup()
                        $itemGroups.append( itemGroup )
                    }
                }
            }
        } detail: {
            if let item = selectedItem {
                DetailView(item: item)
            } else {
                ContentUnavailableView("Please select an item",
                                       systemImage: "hand.point.left")
            }
        }

    }
}

#Preview {
    return MainContentView()
        .environment(\.realm, ItemGroup.previewRealm)
}




