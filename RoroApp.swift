import SwiftUI

@main
struct Roro_iOSApp: App {
    @StateObject private var cartManager = CartManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(cartManager) // هذا يوفّر cartManager لكل الواجهات
        }
    }
}
