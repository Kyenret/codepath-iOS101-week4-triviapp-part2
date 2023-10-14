//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Kyenret Yakubu Ayuba on 10/14/23.
//

import Foundation

class TriviaQuestionService {
    private let urlString = "https://opentdb.com/api.php?amount=5&type=multiple"
    
    func fetchTriviaQuestions(completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(NetworkError.invalidResponse))
                        return
                    }
                    guard let data = data, httpResponse.statusCode == 200 else {
                        completion(.failure(NetworkError.invalidResponseStatusCode(httpResponse.statusCode)))
                        return
                    }
                    do {
                        let triviaResponse = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
                        completion(.success(triviaResponse.questions))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            } else {
                completion(.failure(NetworkError.invalidURL))
            }
        }
    }

    enum NetworkError: Error {
        case invalidResponse
        case invalidResponseStatusCode(Int)
        case invalidURL
    }
    



    
   
