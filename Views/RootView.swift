import SwiftUI

  struct RootView: View {
      @Environment(CartManager.self) private var cartManager

      var body: some View {
          TabView {
              Tab("Home", systemImage: "house.fill") {
                  ContentView()
              }

              Tab("Cart", systemImage: "cart.fill") {
                  CartView()
              }
              .badge(cartManager.items.count)
          }
      }
  }

  #Preview {
      RootView()
          .environment(CartManager())
  }
