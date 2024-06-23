//
//  DetailView.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/7/24.
//

import RealmSwift
import SwiftUI

//not much to see here - just shows the item clicked on in the sideview

struct DetailView: View {
    //@Binding var selectedItem: Item?
    var item: Item
    
    var body: some View {
        Text("Detail View")
        Text("selectedItem: \(item.itemName)")
    }
}

#Preview {
    DetailView(item: Item.item1)
}
