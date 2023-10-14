//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaAPIResponse: Decodable {
    let questions: [TriviaQuestion]
    private enum CodingKeys: String, CodingKey {
        case questions = "results"
    }
}
struct TriviaQuestion: Decodable {
    let category: String
    let questionRaw: String
    var question: String {
        questionRaw.htmlToString
    }
    let correctAnswer: String
    let incorrectAnswers: [String]
    var possibleAnswers: [String] {
        let incorrectAnswersDecoded = self.incorrectAnswers.map { $0.htmlToString }
        return ([correctAnswer.htmlToString] + incorrectAnswersDecoded).shuffled()
    }
    private enum CodingKeys: String, CodingKey {
        case category = "category"
        case questionRaw = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}


//struct TriviaQuestion {
//  let category: String
 // let question: String
//  let correctAnswer: String
//  let incorrectAnswers: [String]
//}


extension String {
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: data,
                                       options: [
                                           .documentType: NSAttributedString.DocumentType.html,
                                           .characterEncoding: String.Encoding.utf8.rawValue
                                       ],
                                       documentAttributes: nil)
    }
}
