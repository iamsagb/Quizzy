//
//  NetworkManager.swift
//  Quizzy
//
//  Created by #include tech. on 24/11/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchQuizQuestions() async throws -> [QuizQuestion] {
        print("NetworkManager: Fetching Quiz Questions")
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple") else {
            print("NetworkManager: Error Invalid URL")
            throw NetworkError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let quizData = try decoder.decode(QuizData.self, from: data)
            return quizData.results
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

