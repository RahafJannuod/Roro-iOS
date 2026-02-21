import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ProductsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let err = vm.errorMessage {
                    VStack {
                        Text("Error: \(err)")
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task { await vm.loadAll() }
                        }
                    }
                } else {
                    List(vm.products) { p in
                        HStack(spacing: 12) {
                            AsyncImage(url: p.image) { ph in
                                switch ph {
                                case .empty: ProgressView()
                                case .success(let img): img.resizable().scaledToFill()
                                case .failure: Image(systemName: "photo")
                                @unknown default: EmptyView()
                                }
                            }
                            .frame(width: 64, height: 64)
                            .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(p.title).font(.body).lineLimit(2)
                                Text(String(format: "$%.2f", p.price)).font(.subheadline).foregroundColor(.accentColor)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Home")
            .task { await vm.loadAll() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}
