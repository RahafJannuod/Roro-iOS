import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Avatar
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 96, height: 96)
                    .foregroundColor(.accentColor)
                    .padding(.top, 24)

                // Name
                Text("Rahaf Jannuod")
                    .font(.title2)
                    .fontWeight(.semibold)

                // Email / handle
                Text("rahaf.jannuod@soundcloud.com")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Buttons / settings
                VStack(spacing: 12) {
                    Button(action: {
                        // action: edit profile
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit profile")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor.opacity(0.12))
                        .cornerRadius(12)
                    }

                    Button(action: {
                        // action: sign out / settings
                    }) {
                        HStack {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary.opacity(0.06))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileView()
}
