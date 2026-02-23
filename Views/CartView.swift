import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cart: CartManager
    @State private var showingCheckoutAlert = false
    @State private var showingSuccessSheet = false
    @State private var lastOrderNumber: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    // نستخدم indices لكي نتمكن من onDelete بسهولة
                    ForEach(0..<cart.items.count, id: \.self) { idx in
                        let item = cart.items[idx]
                        CartItemRow(item: item)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let id = cart.items[index].id
                            cart.remove(id: id)
                        }
                    }
                }
                .listStyle(.plain)

                // Footer:
                VStack(spacing: 12) {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text(String(format: "$%.2f", cart.subtotal()))
                    }
                    HStack {
                        Text("Tax (10%)")
                        Spacer()
                        Text(String(format: "$%.2f", cart.tax()))
                    }
                    Divider()
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", cart.totalPrice()))
                            .font(.title3)
                            .fontWeight(.bold)
                    }

                    Button {
                        // لا ننفذ الشراء مباشرةً، بل نعرض تأكيد
                        showingCheckoutAlert = true
                    } label: {
                        Text("Proceed to Checkout")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 6)
                    // Alert التأكيد
                    .alert("Confirm Purchase", isPresented: $showingCheckoutAlert) {
                        Button("Confirm", role: .destructive) {
                            Task {
                                // عرض مؤشر تحميل بسيط (اختياري)
                                // ننشئ نسخة من العناصر قبل المسح
                                let itemsToOrder = cart.items
                                let total = cart.totalPrice()

                                do {
                                    // ننشئ الطلب على APIClient
                                    let newOrder = try await APIClient.shared.createOrder(from: itemsToOrder, total: total)

                                    // بعد نجاح الإنشاء نمسح العربة
                                    cart.clear()

                                    // نحفظ رقم الطلب لعرضه في شاشة النجاح
                                    lastOrderNumber = newOrder.orderNumber

                                    // نظهر شاشة النجاح
                                    showingSuccessSheet = true
                                } catch {
                                    // في حال فشل الاتصال نعرض alert صغير أو نطبع الخطأ
                                    print("Failed to create order: \(error)")
                                }
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure you want to place the order for \(String(format: "$%.2f", cart.totalPrice()))?")
                    }

                } // end VStack
                .padding()
                .background(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: -4)
                .sheet(isPresented: $showingSuccessSheet) {
                    // شاشة نجاح بسيطة
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 72, height: 72)
                            .foregroundColor(.green)
                            .padding(.top, 40)

                        Text("Order Placed")
                            .font(.title)
                            .fontWeight(.bold)

                        if let n = lastOrderNumber {
                            Text("Order #\(n)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }

                        Text("Thank you for your purchase! Your items will be processed shortly.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)

                        Button("Done") {
                            showingSuccessSheet = false
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            } // end main VStack
        } // end NavigationStack
    } // end body
} // end struct
