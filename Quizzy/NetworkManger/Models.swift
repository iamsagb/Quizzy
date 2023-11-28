//
//  Models.swift
//  Quizzy
//
//  Created by #include tech. on 24/11/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
}


struct QuizQuestion: Decodable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correct_answer: String  
    let incorrect_answers: [String]
}


struct QuizData: Decodable {
    let results: [QuizQuestion]
}
