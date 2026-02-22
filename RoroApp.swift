import SwiftUI

@main
struct Roro_iOSApp: App {
    @StateObject private var cartManager = CartManager()

    var body: some Scene {
        WindowGroup {
            RootView()                  // تأكدي أن RootView موجودة كـ View
                .environmentObject(cartManager)
        }
    }
}
