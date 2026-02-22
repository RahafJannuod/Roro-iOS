import SwiftUI

struct CategoriesGridView: View {
    let categories: [String]
    let onSelect: (String) -> Void

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    onSelect(category)
                }) {
                    Text(category.capitalized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.secondary)
                        .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
    }
}

#if DEBUG
struct CategoriesGridView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesGridView(
            categories: ["men's clothing", "jewelery", "electronics", "women's clothing"],
            onSelect: { _ in }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
