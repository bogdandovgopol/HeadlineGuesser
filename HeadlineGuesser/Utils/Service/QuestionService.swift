//
//  QuestionService.swift
//  HeadlineGuesser
//
//  Created by Bogdan on 25/8/20.
//  Copyright © 2020 Bogdan. All rights reserved.
//

import Foundation

struct QuestionService {
    static let shared = QuestionService()
    private init() { }
    
    func getQuestions(completion: @escaping (Result<[Question], HGError>) -> Void) {
        RESTful.shared.request(path: Constants.feedUrl, method: .get, parameters: nil, headers: nil) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completion(.failure(error))
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                do{
                    let feed = try jsonDecoder.decode(Feed.self, from: data)
                    let questions = feed.questions
                    
                    completion(.success(questions))
                } catch (let error) {
                    debugPrint(error.localizedDescription)
                    completion(.failure(.invalidJson))
                }
            }
        }
    }
}
