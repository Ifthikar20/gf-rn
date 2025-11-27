//
//  ThemedBackground.swift
//  GreatFeelSwiftUI
//
//  Dynamic background based on mood and theme
//

import SwiftUI

struct ThemedBackground<Content: View>: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @Environment(\.colorScheme) var colorScheme

    let content: Content
    let opacity: Double

    init(opacity: Double = 0.3, @ViewBuilder content: () -> Content) {
        self.opacity = opacity
        self.content = content()
    }

    var body: some View {
        ZStack {
            // Background Image
            AsyncImage(url: URL(string: backgroundImageURL)) { phase in
                switch phase {
                case .empty:
                    AppColors.background(for: colorScheme)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                case .failure:
                    AppColors.background(for: colorScheme)
                @unknown default:
                    AppColors.background(for: colorScheme)
                }
            }

            // Overlay for readability
            AppColors.background(for: colorScheme)
                .opacity(opacity)
                .ignoresSafeArea()

            // Content
            content
        }
    }

    private var backgroundImageURL: String {
        themeViewModel.backgroundImage(for: colorScheme)
    }
}

// MARK: - Preview
#Preview {
    ThemedBackground {
        VStack {
            Text("Themed Background")
                .font(AppTypography.heading1())
                .foregroundColor(.white)
        }
    }
    .environmentObject(ThemeViewModel())
}
