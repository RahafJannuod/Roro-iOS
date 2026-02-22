import SwiftUI

struct FeaturedSectionView: View {
     let products: [Product]

     var body: some View {
         VStack(alignment: .leading, spacing: 12) {
             Text("Featured")
                 .font(.system(size: 22, weight: .bold))
                 .foregroundColor(.textDark)
                 .padding(.horizontal)

             ScrollView(.horizontal, showsIndicators: false) {
                 HStack(spacing: 16) {
                     ForEach(products) { product in
                         NavigationLink(destination: ProductDetailView(product: product)) {
                             FeaturedCardView(product: product)
                         }
                         .buttonStyle(.plain)
                     }
                 }
                 .padding(.horizontal)
             }
         }
     }
 }

struct FeaturedCardView: View {
     let product: Product

     var body: some View {
         VStack(alignment: .leading, spacing: 12) {
             // Product Image
             AsyncImage(url: product.image) { image in
                 image
                     .resizable()
                     .scaledToFill()
             } placeholder: {
                 ProgressView()
             }
             .frame(width: 280, height: 200)
             .clipped()
             .cornerRadius(12)

             // Product Info
             VStack(alignment: .leading, spacing: 6) {
                 Text(product.title)
                     .font(.system(size: 16, weight: .semibold))
                     .foregroundColor(.textDark)
                     .lineLimit(2)
                     .multilineTextAlignment(.leading)

                 HStack(spacing: 4) {
                     Image(systemName: "star.fill")
                         .font(.system(size: 12))
                         .foregroundColor(.yellow)
                     Text(String(format: "%.1f", product.rating?.rate ?? 0))
                         .font(.system(size: 13))
                         .foregroundColor(.textLight)
                     Text("(\(product.rating?.count ?? 0))")
                         .font(.system(size: 13))
                         .foregroundColor(.textLight)
                 }

                 Text("$\(product.price, specifier: "%.2f")")
                     .font(.system(size: 20, weight: .bold))
                     .foregroundColor(.primary)
             }
             .padding(.horizontal, 12)
             .padding(.bottom, 12)
         }
         .frame(width: 280)
         .background(Color.backgroundCard)
         .cornerRadius(16)
         .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
     }
 }

#Preview {
     NavigationStack {
         FeaturedSectionView(products: [Product.example, Product.example, Product.example])
             .background(Color.backgroundMain)
     }
 }

