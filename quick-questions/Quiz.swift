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

class Question: NSObject {
    
    var question: String = ""
    var difficulty: QuizDatabaseHelper.Difficulty = .unknown
    
    var allAnswers = [String]()
    var incorrectAnswers = [String]()
    var correctAnswer: String = ""
    var correctIndex = -1
    
    init(jsonDict: NSDictionary) {
        super.init()
        
        if let difficultyString = jsonDict["difficulty"] as? String {
            self.difficulty = QuizDatabaseHelper.Difficulty.fromString(difficultyString)
        }
        
        if let question = jsonDict["question"] as? String {
            self.question = self._correctStringFormat(of: question)
        }
        
        if let correctAnswer = jsonDict["correct_answer"] as? String {
            self.correctAnswer = self._correctStringFormat(of: correctAnswer)
        }
        
        if let incorrectAnswers = jsonDict["incorrect_answers"] as? [String] {
            var stringCorrectedAnswers = [String]()
            for answer in incorrectAnswers {
                stringCorrectedAnswers.append(self._correctStringFormat(of: answer))
            }
            self.incorrectAnswers = stringCorrectedAnswers
        }
        
        allAnswers += incorrectAnswers
        correctIndex = Int.random(in: 0...incorrectAnswers.count)
        if correctIndex == incorrectAnswers.count {
            allAnswers.append(correctAnswer)
        } else {
            allAnswers.insert(correctAnswer, at: correctIndex)
        }
    }
    
    private func _correctStringFormat(of string: String) -> String {
        var stringToChange = string.replacingOccurrences(of: "&quot;", with: "\"")
        stringToChange = stringToChange.replacingOccurrences(of: "&#039;", with: "\'")
        stringToChange = stringToChange.replacingOccurrences(of: "&ntilde;", with: "ñ")
        stringToChange = stringToChange.replacingOccurrences(of: "&aacute;", with: "á")
        return stringToChange
    }
}
