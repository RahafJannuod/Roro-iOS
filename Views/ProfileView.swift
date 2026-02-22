import SwiftUI
import UserNotifications

struct ProfileView: View {
    @EnvironmentObject private var userManager: UserManager
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingLogoutAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        AsyncImage(url: userManager.avatarURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())

                        VStack(spacing: 8) {
                            Text(userManager.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            Text(userManager.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 20)

                    // Account Section
                    ProfileSection(title: "Account") {
                        NavigationLink(destination: EditProfileView()) {
                            ProfileRowView(
                                icon: "person.crop.circle",
                                title: "Edit Profile",
                                showChevron: true
                            )
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.horizontal)

                        NavigationLink(destination: OrderHistoryView()) {
                            ProfileRowView(
                                icon: "bag",
                                title: "Order History",
                                showChevron: true
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    // Preferences Section
                    ProfileSection(title: "Preferences") {
                        HStack(spacing: 16) {
                            Image(systemName: "moon")
                                .font(.system(size: 18))
                                .foregroundColor(.accentColor)
                                .frame(width: 24, height: 24)

                            Text("Dark Mode")
                                .font(.body)
                                .foregroundColor(.primary)

                            Spacer()

                            Toggle("", isOn: $isDarkMode)
                                .labelsHidden()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)

                        Divider()
                            .padding(.horizontal)

                        HStack(spacing: 16) {
                            Image(systemName: "bell")
                                .font(.system(size: 18))
                                .foregroundColor(.accentColor)
                                .frame(width: 24, height: 24)

                            Text("Notifications")
                                .font(.body)
                                .foregroundColor(.primary)

                            Spacer()

                            Toggle("", isOn: $notificationsEnabled)
                                .labelsHidden()
                                .onChange(of: notificationsEnabled) { _, newValue in
                                    if newValue {
                                        requestNotificationPermission()
                                    }
                                }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                    }

                    // Support Section
                    ProfileSection(title: "Support") {
                        Button(action: {
                            // Help Center action
                        }) {
                            ProfileRowView(
                                icon: "questionmark.circle",
                                title: "Help Center",
                                showChevron: true
                            )
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.horizontal)

                        Button(action: {
                            // Contact Us action
                        }) {
                            ProfileRowView(
                                icon: "envelope",
                                title: "Contact Us",
                                showChevron: true
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    // Logout Button
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .alert("Log Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                userManager.logout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if !granted {
                    notificationsEnabled = false
                }
            }
        }
    }
}

struct ProfileSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)

            VStack(spacing: 0) {
                content
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct ProfileRowView: View {
    let icon: String
    let title: String
    let showChevron: Bool

    init(icon: String, title: String, showChevron: Bool = false) {
        self.icon = icon
        self.title = title
        self.showChevron = showChevron
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.accentColor)
                .frame(width: 24, height: 24)

            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserManager())
}
