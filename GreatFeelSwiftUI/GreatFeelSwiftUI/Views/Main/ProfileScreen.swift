//
//  ProfileScreen.swift
//  GreatFeelSwiftUI
//
//  Modern Profile screen with vibrant design and dark mode
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @Environment(\.colorScheme) var colorScheme

    // Simple solid background
    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(hex: "0F172A")
            : Color(hex: "F8FAFC")
    }

    var body: some View {
        ZStack {
            // Clean background
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Simple Profile Header
                    profileHeader
                        .padding(.top, 20)

                    // Quick Stats
                    quickStats

                    // Essential Settings
                    settingsSection

                    // Logout Button
                    logoutButton

                    // Version
                    Text("Version 1.0.0")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4))
                        .padding(.vertical, 16)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Simple Avatar
            ZStack {
                AsyncImage(url: URL(string: authViewModel.user?.avatar ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .empty, .failure, _:
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "7C3AED"), Color(hex: "A78BFA")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            Image(systemName: "person.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "7C3AED").opacity(0.3), Color(hex: "A78BFA").opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
            }

            // Name and Email
            VStack(spacing: 6) {
                Text(authViewModel.user?.name ?? "Alex Thompson")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : Color(hex: "1E293B"))

                Text(authViewModel.user?.email ?? "alex@greatfeel.com")
                    .font(.system(size: 14))
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color(hex: "64748B"))
            }
        }
    }

    // MARK: - Quick Stats
    private var quickStats: some View {
        HStack(spacing: 12) {
            QuickStat(icon: "flame.fill", value: "7", label: "Streak", color: .orange)
            QuickStat(icon: "leaf.circle.fill", value: "850", label: "Points", color: Color(hex: "7C3AED"))
            QuickStat(icon: "clock.fill", value: "156", label: "Minutes", color: Color(hex: "3B82F6"))
        }
    }

    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(spacing: 0) {
            // Dark Mode
            SettingRow(
                icon: "moon.stars.fill",
                iconColor: Color(hex: "7C3AED"),
                title: "Dark Mode",
                hasToggle: true,
                isOn: Binding(
                    get: { themeViewModel.themeMode == .dark },
                    set: { _ in themeViewModel.toggleDarkMode() }
                )
            )

            Divider()
                .padding(.leading, 56)
                .background(colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.05))

            // Notifications
            SettingRow(
                icon: "bell.badge.fill",
                iconColor: Color(hex: "3B82F6"),
                title: "Notifications"
            )

            Divider()
                .padding(.leading, 56)
                .background(colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.05))

            // Privacy
            SettingRow(
                icon: "lock.shield.fill",
                iconColor: Color(hex: "10B981"),
                title: "Privacy & Security"
            )

            Divider()
                .padding(.leading, 56)
                .background(colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.05))

            // Help
            SettingRow(
                icon: "questionmark.circle.fill",
                iconColor: Color(hex: "F59E0B"),
                title: "Help & Support"
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.white.opacity(0.05) : .white)
                .shadow(
                    color: colorScheme == .dark ? .clear : Color.black.opacity(0.05),
                    radius: 10,
                    y: 2
                )
        )
    }

    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            Task {
                await authViewModel.logout()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 15, weight: .semibold))
                Text("Sign Out")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Quick Stat Component
struct QuickStat: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(colorScheme == .dark ? .white : Color(hex: "1E293B"))

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.5) : Color(hex: "94A3B8"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color.white.opacity(0.05) : .white)
                .shadow(
                    color: colorScheme == .dark ? .clear : Color.black.opacity(0.04),
                    radius: 8,
                    y: 2
                )
        )
    }
}

// MARK: - Setting Row Component
struct SettingRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    var hasToggle: Bool = false
    var isOn: Binding<Bool>? = nil
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: hasToggle ? {} : {}) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 40, height: 40)

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }

                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(colorScheme == .dark ? .white : Color(hex: "1E293B"))

                Spacer()

                if hasToggle, let binding = isOn {
                    Toggle("", isOn: binding)
                        .labelsHidden()
                        .tint(Color(hex: "7C3AED"))
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.3) : Color(hex: "CBD5E1"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .disabled(hasToggle)
    }
}

// MARK: - Preview
#Preview {
    ProfileScreen()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeViewModel())
        .preferredColorScheme(.dark)
}
