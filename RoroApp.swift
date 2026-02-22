import SwiftUI

@main
struct Roro_iOSApp: App {
    @StateObject private var cartManager = CartManager()
    @StateObject private var userManager = UserManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(cartManager)
                .environmentObject(userManager)
        }
    }
}
