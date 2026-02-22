//
//  EditProfileView.swift
//  Roro-iOS
//
//  Created by Rahaf jannuod on 22.02.26.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject private var userManager: UserManager
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                        .textContentType(.name)

                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }

                Section {
                    Button(action: saveProfile) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                            Text("Save Changes")
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isLoading || name.isEmpty || email.isEmpty)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            name = userManager.name
            email = userManager.email
        }
    }

    private func saveProfile() {
        isLoading = true
        userManager.updateProfile(name: name, email: email)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            dismiss()
        }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(UserManager())
}
