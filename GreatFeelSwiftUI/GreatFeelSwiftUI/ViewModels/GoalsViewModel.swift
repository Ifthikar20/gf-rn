//
//  GoalsViewModel.swift
//  GreatFeelSwiftUI
//
//  Goals state management
//

import Foundation
import Combine

@MainActor
class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    init() {
        loadGoals()
    }

    // MARK: - Load Goals
    func loadGoals() {
        isLoading = true
        errorMessage = nil

        // Simulate network delay
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            goals = Goal.mockGoals
            isLoading = false
        }
    }

    // MARK: - Goals by Time of Day
    func goals(for timeOfDay: TimeOfDay) -> [Goal] {
        goals.filter { $0.timeOfDay == timeOfDay }
    }

    // MARK: - Toggle Goal Completion
    func toggleGoalCompletion(_ goalId: String) {
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            // Toggle completion status
            goals[index] = Goal(
                id: goals[index].id,
                title: goals[index].title,
                description: goals[index].description,
                type: goals[index].type,
                category: goals[index].category,
                duration: goals[index].duration,
                thumbnail: goals[index].thumbnail,
                timeOfDay: goals[index].timeOfDay,
                isLocked: goals[index].isLocked,
                isCompleted: !goals[index].isCompleted,
                streak: goals[index].streak
            )
        }
    }

    // MARK: - Computed Properties
    var morningGoals: [Goal] {
        goals(for: .morning)
    }

    var dayGoals: [Goal] {
        goals(for: .day)
    }

    var eveningGoals: [Goal] {
        goals(for: .evening)
    }

    var completedCount: Int {
        goals.filter { $0.isCompleted }.count
    }

    var totalCount: Int {
        goals.count
    }

    var progressPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
}
