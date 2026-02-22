import SwiftUI

struct LoginView: View {

    @EnvironmentObject private var userManager: UserManager

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 24) {

            Spacer()

            Text("Welcome Back")
                .font(.system(size: 32, weight: .bold))

            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            Button {
                login()
            } label: {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }

    private func login() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            userManager.isLoggedIn = true
            isLoading = false
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(UserManager())
}
