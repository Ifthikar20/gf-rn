//
//  ProfileScreen.swift
//  GreatFeelSwiftUI
//
//  Profile screen with settings
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ThemedBackground(opacity: 0.85) {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    // Profile Header
                    profileHeader

                    // Mood Selector Section
                    moodSection

                    // Dark Mode Toggle
                    darkModeSection

                    // Audio Mute Toggle
                    audioSection

                    // Menu Items
                    menuSection

                    // Logout Button
                    logoutButton

                    // Version
                    Text("Version 1.0.0")
                        .font(AppTypography.caption())
                        .foregroundColor(AppColors.textTertiary(for: colorScheme))

                    Spacer(minLength: AppSpacing.xl2)
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: AppSpacing.md) {
            // Avatar
            AsyncImage(url: URL(string: authViewModel.user?.avatar ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .empty, .failure, _:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(AppColors.primary(for: colorScheme))
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(Circle().stroke(AppColors.primary(for: colorScheme), lineWidth: 2))

            // Name and Email
            VStack(spacing: 4) {
                Text(authViewModel.user?.name ?? "User")
                    .font(AppTypography.heading4())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))

                Text(authViewModel.user?.email ?? "user@example.com")
                    .font(AppTypography.small())
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
            }
        }
        .padding(.top, AppSpacing.lg)
    }

    // MARK: - Mood Section
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("How are you feeling?")
                .font(AppTypography.heading6())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
                .padding(.horizontal, AppSpacing.md)

            MoodSelector(selectedMood: $themeViewModel.selectedMood)
        }
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.surface(for: colorScheme).opacity(0.5))
        .cornerRadius(AppSpacing.Radius.lg)
    }

    // MARK: - Dark Mode Section
    private var darkModeSection: some View {
        HStack {
            Image(systemName: "moon.fill")
                .font(.system(size: AppSpacing.IconSize.md))
                .foregroundColor(AppColors.textSecondary(for: colorScheme))
                .frame(width: 30)

            Text("Dark Mode")
                .font(AppTypography.body())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))

            Spacer()

            Toggle("", isOn: Binding(
                get: { themeViewModel.themeMode == .dark },
                set: { _ in themeViewModel.toggleDarkMode() }
            ))
            .labelsHidden()
            .tint(AppColors.primary(for: colorScheme))
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface(for: colorScheme).opacity(0.5))
        .cornerRadius(AppSpacing.Radius.lg)
    }

    // MARK: - Audio Section
    private var audioSection: some View {
        HStack {
            Image(systemName: themeViewModel.isAudioMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .font(.system(size: AppSpacing.IconSize.md))
                .foregroundColor(AppColors.textSecondary(for: colorScheme))
                .frame(width: 30)

            Text("Background Audio")
                .font(AppTypography.body())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))

            Spacer()

            Toggle("", isOn: Binding(
                get: { !themeViewModel.isAudioMuted },
                set: { _ in themeViewModel.toggleAudioMute() }
            ))
            .labelsHidden()
            .tint(AppColors.primary(for: colorScheme))
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface(for: colorScheme).opacity(0.5))
        .cornerRadius(AppSpacing.Radius.lg)
    }

    // MARK: - Menu Section
    private var menuSection: some View {
        VStack(spacing: 0) {
            menuItem(icon: "person.fill", title: "Edit Profile")
            Divider().padding(.leading, 46)
            menuItem(icon: "bell.fill", title: "Notifications")
            Divider().padding(.leading, 46)
            menuItem(icon: "lock.fill", title: "Data & Privacy")
            Divider().padding(.leading, 46)
            menuItem(icon: "questionmark.circle.fill", title: "Help")
            Divider().padding(.leading, 46)
            menuItem(icon: "doc.text.fill", title: "Terms & Conditions")
        }
        .background(AppColors.surface(for: colorScheme).opacity(0.5))
        .cornerRadius(AppSpacing.Radius.lg)
    }

    private func menuItem(icon: String, title: String) -> some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: AppSpacing.IconSize.md))
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    .frame(width: 30)

                Text(title)
                    .font(AppTypography.body())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: AppSpacing.IconSize.sm))
                    .foregroundColor(AppColors.textTertiary(for: colorScheme))
            }
            .padding(AppSpacing.md)
        }
    }

    // MARK: - Logout Button
    private var logoutButton: some View {
        PrimaryButton(
            "Sign Out",
            variant: .outline,
            size: .large,
            isLoading: authViewModel.isLoading
        ) {
            Task {
                await authViewModel.logout()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ProfileScreen()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeViewModel())
}
