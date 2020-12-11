//
//  Quiz.swift
//  quick-questions
//
//  Created by Francesco Prospato on 11/4/20.
//

import Foundation

class Quiz: NSObject {
    
    var questions = [Question]()
    var questionIndex = 0
    var currentQuestion: Question?
    var correctAnswersCount = 0
    
    init(from data: Data) {
        
        do {
            guard let jsonResults = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary,
                  let results = jsonResults["results"] as? [AnyObject] else {
                
                return
            }
            
            for result in results {
                if let jsonDict = result as? NSDictionary {
                    questions.append(Question(jsonDict: jsonDict))
                }
            }
            
            print("result")
            
        } catch {
            print("Hey Listen! Could not decode result: \(error.localizedDescription)")
        }
    }
    
    func getNextQuestion() -> Question? {
        let question = questionIndex < questions.count ? questions[questionIndex] : nil
        
        questionIndex += 1
        currentQuestion = question
        
        return question
    }
    
}
