//
//  User.swift
//  Close
//
//  Created by SF on 8/9/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String? // Automatically synthesized by Firestore for the document ID
    var username: String
    var userBio: String
    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
}
