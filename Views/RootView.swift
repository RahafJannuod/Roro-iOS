import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ProductListView()
                .tabItem {
                    Label("Products", systemImage: "shippingbox")
                }

            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}
