//
//  CloseApp.swift
//  Close
//
//  Created by SF on 8/9/23.
//

import SwiftUI
import Firebase

@main
struct CloseApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
