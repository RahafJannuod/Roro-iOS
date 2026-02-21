import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ProductsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                
                if vm.isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                else if let err = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text("Error: \(err)")
                            .foregroundColor(.red)
                        
                        Button("Retry") {
                            Task {
                                await vm.loadAll()
                            }
                        }
                    }
                }
                
                else {
                    List(vm.products) { p in
                        
                        NavigationLink(destination: ProductDetailView(product: p)) {
                            
                            HStack(spacing: 12) {
                                
                                AsyncImage(url: p.image) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure:
                                        Image(systemName: "photo")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: 64, height: 64)
                                .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(p.title)
                                        .font(.body)
                                        .lineLimit(2)
                                    
                                    Text("$\(p.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Home")
            .task {
                await vm.loadAll()
            }
        }
    }
}

#Preview {
    ContentView()
}
