import SwiftUI

/// ProductFiltersView.swift
/// شريط الفلاتر: شورت للـ categories و menu للـ sort و زر "Clear"
struct ProductFiltersView: View {
    // بيانات من الأب (Binding) لكي نتحكم من ContentView / ViewModel
    let categories: [String]
    @Binding var selectedCategory: String?
    @Binding var sortOption: SortOption
    let onClear: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // 1) شريط التصنيفات — scroll أفقي من الشِيبس
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button(action: {
                        selectedCategory = nil
                    }) {
                        Text("All")
                            .font(.subheadline).bold()
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(selectedCategory == nil ? Color.primary : Color.backgroundCard)
                            .foregroundColor(selectedCategory == nil ? Color.white : Color.textDark)
                            .clipShape(Capsule())
                    }
                    ForEach(categories, id: \.self) { cat in
                        Button(action: {
                            selectedCategory = cat
                        }) {
                            Text(cat.capitalized)
                                .font(.subheadline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(selectedCategory == cat ? Color.primary : Color.backgroundCard)
                                .foregroundColor(selectedCategory == cat ? Color.white : Color.textDark)
                                .overlay(
                                    Capsule().stroke(Color.borderColor, lineWidth: selectedCategory == cat ? 0 : 1)
                                )
                        }
                        .accessibilityLabel("Category \(cat)")
                    }
                }
                .padding(.horizontal, 12)
            }

            // 2) Sort + Clear row
            HStack {
                Menu {
                    Button("None") { sortOption = .none }
                    Button("Price ↑") { sortOption = .priceAsc }
                    Button("Price ↓") { sortOption = .priceDesc }
                    Button("Rating ↓") { sortOption = .ratingDesc }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.arrow.down")
                        Text("Sort")
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.backgroundCard)
                    .cornerRadius(10)
                }

                Spacer()

                Button(action: {
                    onClear()
                }) {
                    Text("Clear")
                        .font(.subheadline).bold()
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.clear)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 8)
        .background(Color.clear)
    }
}

// MARK: - Preview
#if DEBUG
struct ProductFiltersView_Previews: PreviewProvider {
    @State static var cat: String? = nil
    @State static var sort: SortOption = .none

    static var previews: some View {
        ProductFiltersView(categories: ["men's clothing","jewelery","electronics"], selectedCategory: $cat, sortOption: $sort) {
            cat = nil
            sort = .none
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
