//
//  Realm_SwiftUI_macOSApp.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/4/24.
//

import RealmSwift
import SwiftUI

let config = Realm.Configuration(schemaVersion: 0)

//insert YOUR appId here
let kAppId = "your-appId-here"


@main
struct Realm_SwiftUI_macOSApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(CGSize(width: 600, height: 500))
    }
}


