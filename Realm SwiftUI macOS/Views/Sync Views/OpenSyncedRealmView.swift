//
//  OpenSyncedRealmView.swift
//  Realm SwiftUI macOS
//
//  Created by Jay Wooten on 6/10/24.
//

import RealmSwift
import SwiftUI

///     struct ContentView: View {
///         let start = Date().addingTimeInterval(-30)
///         let end = Date().addingTimeInterval(90)
///
///         var body: some View {
///             ProgressView(interval: start...end,
///                          countsDown: false) {
///                 Text("Progress")
///             } currentValueLabel: {
///                 Text(start...end)
///              }
///          }
///     }

struct OpenSyncedRealmView: View {
    // We've injected a `flexibleSyncConfiguration` as an environment value,
    // so `@AsyncOpen` here opens a realm using that configuration.
    @AsyncOpen(appId: kAppId, timeout: 4000) var asyncOpen

    var body: some View {
        let _ = print("OpenSyncedRealmView")
        // Because we are setting the `ownerId` to the `user.id`, we need
        // access to the app's current user in this view.
        switch asyncOpen {

        case .connecting:
            // Starting the Realm.asyncOpen process.
            // Show a progress view.
            let _ = print("connecting")
            let start = Date().addingTimeInterval(-30)
            let end = Date().addingTimeInterval(90)
            ProgressView(timerInterval: start...end,
                         countsDown: false) {
                Text("Progress")
            } currentValueLabel: {
                Text(start...end)
            }

        case .waitingForUser:
            // Waiting for a user to be logged in before executing
            let _ = print("waiting for user")
            ProgressView("Waiting for user to log in...")

        case .open(_):
            // The realm has been opened and is ready for use.
            // Show the content view.
            let _ = print("open")
            MainContentView()
            

        case .progress(let progress):
            // The realm is currently being downloaded from the server.
            // Show a progress view.
            let _ = print("progress")
            ProgressView(progress)

        case .error(let error):
            // Opening the Realm failed.
            // Show an error view.
            let _ = print("error: \(error.localizedDescription)")
            //ErrorView(error: error)
        }
    }
}

#Preview {
    OpenSyncedRealmView()
}
