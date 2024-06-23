//
//  TestView.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/11/24.
//

import RealmSwift
import SwiftUI

//called from the ContentView to start the sync'ing process. Note we are using anonymous auth so when
//  a session expires or logged out, the anonymous user id changes so the data will not be available locally
//  but will still be on the server

struct SyncContentView: View {
    @State var isLoggingOut = false
    @State var isLoggingIn = false
    @State var isContinuing = false
    @ObservedObject var observedApp = RealmSwift.App(id: kAppId)

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("1) If you're logged out, log in to begin a session, then continue")
                Text("2) If you logged in and want to start a new session, log out, then log back in and continue")
                Text("3) To clear the realm files, log out, then delete Realm")
            }

            HStack {
                Button("Log out") {
                    guard let _ = observedApp.currentUser else {
                        return
                    }
                    isLoggingOut = true
                    Task {
                        do {
                            try await observedApp.currentUser!.logOut()
                            // Other views are observing the app and will detect
                            // that the currentUser has changed. Nothing more to do here.
                        } catch {
                            print("Error logging out: \(error.localizedDescription)")
                        }
                    }
                }.disabled(observedApp.currentUser == nil || isLoggingOut)

                Button("Log in") {
                    isLoggingIn = true
                    Task {
                        do {
                            let user = try await observedApp.login(credentials: .anonymous)
                            // Other views are observing the app and will detect
                            // that the currentUser has changed. Nothing more to do here.
                            print("Logged in as user with id: \(user.id)")
                        } catch {
                            print("Failed to log in: \(error.localizedDescription)")
                            // Set error to observed property so it can be displayed
                            return
                        }
                    }
                }.disabled(observedApp.currentUser != nil || isLoggingIn)
                
                NavigationLink("Continue", destination: SyncSetupView(app: observedApp))
                    .disabled(observedApp.currentUser == nil)
            }


            Button("delete realm") { //this only deletes local data
                print("deleting")
                do {
                    let isSuccess = try RealmSwift.Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
                    print("was deleted?: \(isSuccess)")
                } catch {
                    print("delete failed")
                }
            }
        }
    }
}

#Preview {
    SyncContentView(observedApp: RealmSwift.App(id: kAppId))
}
