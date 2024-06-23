//
//  ContentView.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/20/24.
//

import RealmSwift
import SwiftUI

//present two buttons: one to use a local only realm
// and one to start the syncing realm

//note the local only realm file will be stored in your project folder - the path is derived from
//  the getRealmPath function and environment injected in the receiving MainContentView so it uses
//  the local file

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HStack() {
                NavigationLink("Local Only Realm", destination: MainContentView().environment(\.realmConfiguration, Realm.Configuration( fileURL: getRealmPath() ) ) )

                Divider()
                    .frame(height: 100)

                NavigationLink("Sync'd Realm", destination: SyncContentView())
            }
            .padding()
        }
    }
    
    func getRealmConfig() -> Realm.Configuration {
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL = getRealmPath()
        return config
    }

    func getRealmPath() -> URL {
        let path = #file
        let url = URL(fileURLWithPath: path)
        let projectSubFolder = url.deletingLastPathComponent()
        let projectFolder = projectSubFolder.deletingLastPathComponent()
        let pathToThisRealmFile = projectFolder.appending(path: "default.realm")
        print("Your local only realm file is stored here: \n\(pathToThisRealmFile)")

        return pathToThisRealmFile
    }
}

#Preview {
    ContentView()
}
