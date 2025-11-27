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

    // Dynamic vibrant gradient background
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(hex: "0F172A"), Color(hex: "1E1B4B"), Color(hex: "312E81")]
                : [Color(hex: "FDF4FF"), Color(hex: "FAE8FF"), Color(hex: "F3E8FF")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ZStack {
            // Vibrant Background
            backgroundGradient
                .ignoresSafeArea()

            // Floating gradient orbs
            GeometryReader { proxy in
                Circle()
                    .fill(AppColors.secondary(for: colorScheme).opacity(colorScheme == .dark ? 0.15 : 0.2))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: proxy.size.width - 200, y: -100)

                Circle()
                    .fill(AppColors.primary(for: colorScheme).opacity(colorScheme == .dark ? 0.12 : 0.15))
                    .frame(width: 250, height: 250)
                    .blur(radius: 50)
                    .offset(x: -50, y: proxy.size.height - 150)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Profile Header
                    modernProfileHeader

                    // Stats Cards
                    statsRow

                    // Appearance Section
                    appearanceSection

                    // Menu Items
                    modernMenuSection

                    // Logout Button
                    modernLogoutButton

                    // Version
                    Text("Version 1.0.0 • GreatFeel")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textTertiary : AppColors.Light.textTertiary)
                        .padding(.top, 8)

                    Spacer(minLength: 60)
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Modern Profile Header
    private var modernProfileHeader: some View {
        VStack(spacing: 16) {
            // Avatar with gradient border
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.primary(for: colorScheme),
                                AppColors.secondary(for: colorScheme)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                AsyncImage(url: URL(string: authViewModel.user?.avatar ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .empty, .failure, _:
                        ZStack {
                            Circle()
                                .fill(colorScheme == .dark ? AppColors.Dark.surface : AppColors.Light.surface)
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(AppColors.primary(for: colorScheme))
                        }
                    }
                }
                .frame(width: 92, height: 92)
                .clipShape(Circle())
            }
            .shadow(color: AppColors.primary(for: colorScheme).opacity(0.3), radius: 12, y: 6)

            // Name and Email
            VStack(spacing: 6) {
                Text(authViewModel.user?.name ?? "Alex Thompson")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)

                Text(authViewModel.user?.email ?? "alex@greatfeel.com")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
            }

            // Edit Profile Button
            Button(action: {}) {
                HStack(spacing: 6) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .semibold))
                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(AppColors.primary(for: colorScheme))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(AppColors.primary(for: colorScheme).opacity(0.1))
                .cornerRadius(20)
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "flame.fill",
                value: "7",
                label: "Day Streak",
                color: .orange,
                colorScheme: colorScheme
            )

            StatCard(
                icon: "target",
                value: "24",
                label: "Goals Done",
                color: AppColors.Category.relax,
                colorScheme: colorScheme
            )

            StatCard(
                icon: "clock.fill",
                value: "156",
                label: "Minutes",
                color: AppColors.primary(for: colorScheme),
                colorScheme: colorScheme
            )
        }
    }

    // MARK: - Appearance Section
    private var appearanceSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "paintbrush.fill")
                    .foregroundStyle(AppColors.primary(for: colorScheme))
                Text("Appearance")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
                Spacer()
            }

            VStack(spacing: 0) {
                // Dark Mode Toggle
                ModernToggleRow(
                    icon: "moon.stars.fill",
                    iconColor: AppColors.Category.sleep,
                    title: "Dark Mode",
                    isOn: Binding(
                        get: { themeViewModel.themeMode == .dark },
                        set: { _ in themeViewModel.toggleDarkMode() }
                    ),
                    colorScheme: colorScheme
                )

                Divider()
                    .padding(.leading, 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.03))

                // Audio Toggle
                ModernToggleRow(
                    icon: "speaker.wave.2.fill",
                    iconColor: AppColors.primary(for: colorScheme),
                    title: "Background Audio",
                    isOn: Binding(
                        get: { !themeViewModel.isAudioMuted },
                        set: { _ in themeViewModel.toggleAudioMute() }
                    ),
                    colorScheme: colorScheme
                )
            }
            .background(.ultraThinMaterial)
            .background(
                colorScheme == .dark
                    ? AppColors.Dark.surface.opacity(0.6)
                    : AppColors.Light.surface.opacity(0.8)
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        colorScheme == .dark
                            ? Color.white.opacity(0.05)
                            : Color.black.opacity(0.03),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark
                    ? Color.black.opacity(0.3)
                    : Color.black.opacity(0.05),
                radius: 8,
                y: 4
            )
        }
    }

    // MARK: - Modern Menu Section
    private var modernMenuSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(AppColors.primary(for: colorScheme))
                Text("Settings")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
                Spacer()
            }

            VStack(spacing: 0) {
                ModernMenuRow(
                    icon: "bell.fill",
                    iconColor: AppColors.Category.relax,
                    title: "Notifications",
                    colorScheme: colorScheme
                )

                Divider()
                    .padding(.leading, 50)

                ModernMenuRow(
                    icon: "lock.shield.fill",
                    iconColor: AppColors.Category.breath,
                    title: "Privacy & Security",
                    colorScheme: colorScheme
                )

                Divider()
                    .padding(.leading, 50)

                ModernMenuRow(
                    icon: "heart.fill",
                    iconColor: .pink,
                    title: "Health Integration",
                    colorScheme: colorScheme
                )

                Divider()
                    .padding(.leading, 50)

                ModernMenuRow(
                    icon: "questionmark.circle.fill",
                    iconColor: AppColors.secondary(for: colorScheme),
                    title: "Help & Support",
                    colorScheme: colorScheme
                )

                Divider()
                    .padding(.leading, 50)

                ModernMenuRow(
                    icon: "doc.text.fill",
                    iconColor: AppColors.Category.meditation,
                    title: "Terms & Privacy Policy",
                    colorScheme: colorScheme
                )
            }
            .background(.ultraThinMaterial)
            .background(
                colorScheme == .dark
                    ? AppColors.Dark.surface.opacity(0.6)
                    : AppColors.Light.surface.opacity(0.8)
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        colorScheme == .dark
                            ? Color.white.opacity(0.05)
                            : Color.black.opacity(0.03),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark
                    ? Color.black.opacity(0.3)
                    : Color.black.opacity(0.05),
                radius: 8,
                y: 4
            )
        }
    }

    // MARK: - Modern Logout Button
    private var modernLogoutButton: some View {
        Button(action: {
            Task {
                await authViewModel.logout()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                Text("Sign Out")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial)
            .background(Color.red.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let colorScheme: ColorScheme

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(color)
            }

            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .background(
            colorScheme == .dark
                ? AppColors.Dark.surface.opacity(0.6)
                : AppColors.Light.surface.opacity(0.8)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.05)
                        : Color.black.opacity(0.03),
                    lineWidth: 1
                )
        )
        .shadow(
            color: colorScheme == .dark
                ? Color.black.opacity(0.3)
                : Color.black.opacity(0.05),
            radius: 8,
            y: 4
        )
    }
}

// MARK: - Modern Toggle Row
struct ModernToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var isOn: Bool
    let colorScheme: ColorScheme

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppColors.primary(for: colorScheme))
        }
        .padding(14)
    }
}

// MARK: - Modern Menu Row
struct ModernMenuRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let colorScheme: ColorScheme

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(iconColor)
                }

                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textTertiary : AppColors.Light.textTertiary)
            }
            .padding(14)
        }
    }
}

// MARK: - Preview
#Preview {
    ProfileScreen()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeViewModel())
        .preferredColorScheme(.dark)
}
