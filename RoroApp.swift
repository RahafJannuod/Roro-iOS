import SwiftUI

@main
struct RoroApp: App {
    @State private var cart = CartManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(cart)   // inject CartManager into the app
        }
    }
}
