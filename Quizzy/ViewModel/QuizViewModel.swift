//
//  QuizViewModel.swift
//  Quizzy
//
//  Created by #include tech. on 28/11/23.
//

import UIKit
import Combine

class QuizViewModel {
    @Published var quizData: [QuizQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""

    private var cancellables: Set<AnyCancellable> = []

    func fetchQuizData() {
        isLoading = true

        Task {
            do {
                let data = try await NetworkManager.shared.fetchQuizQuestions()
                quizData = data
                isLoading = false
            } catch {
                showAlert(with: "Error", message: "Failed to fetch quiz data. \(error.localizedDescription)")
            }
        }
    }

    func showAlert(with title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
