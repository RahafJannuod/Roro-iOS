import Foundation
import SwiftUI
import Combine

final class UserManager: ObservableObject {

    @Published var name: String = "John Doe"
    @Published var email: String = "john.doe@email.com"
    @Published var avatarURL: URL? = URL(string: "https://i.pravatar.cc/200")
    @Published var isLoggedIn: Bool = true

    func logout() {
        // في تطبيق حقيقي هنا تمسحين التوكن
        name = "Guest"
        email = "guest@email.com"
        avatarURL = nil
        isLoggedIn = false
        print("User logged out")
    }

    func updateProfile(name: String, email: String) {
        self.name = name
        self.email = email

        Task {
            do {
                try await APIClient.shared.updateProfile(name: name, email: email)
                print("Profile updated successfully")
            } catch {
                print("Failed to update profile: \(error)")
            }
        }
    }
}
