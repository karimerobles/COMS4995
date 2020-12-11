//
//  Question.swift
//  quick-questions
//
//  Created by karime robles on 12/10/20.
//

import Foundation

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
        stringToChange = stringToChange.replacingOccurrences(of: "&ldquo;", with: "\"")
        stringToChange = stringToChange.replacingOccurrences(of: "&rdquo;", with: "\"")
        stringToChange = stringToChange.replacingOccurrences(of: "&rsquo;", with: "\'")
        stringToChange = stringToChange.replacingOccurrences(of: "&hellip;", with: "...")
        stringToChange = stringToChange.replacingOccurrences(of: "&ntilde;", with: "ñ")
        stringToChange = stringToChange.replacingOccurrences(of: "&aacute;", with: "á")
        return stringToChange
    }
}
