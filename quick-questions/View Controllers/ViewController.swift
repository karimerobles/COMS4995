//
//  ViewController.swift
//  quick-questions
//
//  Created by karime on 10/7/20.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var option3Btn: UIButton!
    @IBOutlet weak var option4Btn: UIButton!
    @IBOutlet weak var answerBtn: UIButton!

    // MARK: - Variables

    var selectedOption = 0
    var isProcessingAnswer = false
    var isCorrectAnswer = false
    
    var quiz: Quiz?
    
    let selectedColor = UIColor.white.withAlphaComponent(0.85)
    let notSelectedColor = UIColor(red: 115.0/255.0, green: 187.0/255.0, blue: 97.0/255.0, alpha: 0.85)

    // MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupView()
    }
    /// set up view
    ///
    private func _setupView() {
        questionLbl.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        questionLbl.textAlignment = .center
        questionLbl.numberOfLines = 0
        
        option1Btn.layer.cornerRadius = 10
        option1Btn.accessibilityLabel = "option1"
        option2Btn.layer.cornerRadius = 10
        option2Btn.accessibilityLabel = "option2"
        option3Btn.layer.cornerRadius = 10
        option3Btn.accessibilityLabel = "option3"
        option4Btn.layer.cornerRadius = 10
        option4Btn.accessibilityLabel = "option4"
        
        answerBtn.setTitle("Check Answer", for: .normal)
        answerBtn.layer.cornerRadius = 10
        
        guard let quiz = quiz, let question = quiz.getNextQuestion() else { return }
        _setViewWithQuestion(with: question)
        
        progress.progress = (Float(quiz.questionIndex)/Float(quiz.questions.count))
        progress.layer.cornerRadius = 10
        progress.clipsToBounds = true
        progress.layer.sublayers![1].cornerRadius = 10
        progress.subviews[1].clipsToBounds = true
    }
    
    private func _setViewWithQuestion(with question: Question) {
        DispatchQueue.main.async {
            if question.correctAnswer == "" || question.incorrectAnswers.count == 0 { print("error") }
            
            self.questionLbl.text = question.question
            
            var counter = 0
            for incorrectAnswer in question.allAnswers {
                if counter == 0 {
                    self.option1Btn.setTitle(incorrectAnswer, for: .normal)
                } else if counter == 1 {
                    self.option2Btn.setTitle(incorrectAnswer, for: .normal)
                } else if counter == 2 {
                    self.option3Btn.setTitle(incorrectAnswer, for: .normal)
                } else {
                    self.option4Btn.setTitle(incorrectAnswer, for: .normal)
                }
                counter += 1
            }
            
        }
    }

    // MARK: - Selection actions

    @IBAction func option1Tap(_ sender: Any) {
        selectOption1(isUnitTest: false)
    }

    func selectOption1(isUnitTest: Bool) {
        if !isProcessingAnswer {
            selectedOption = selectedOption == 1 ? 0 : 1
            
            if !isUnitTest {
                option1Btn.backgroundColor = selectedOption == 1 ? selectedColor : notSelectedColor
                option2Btn.backgroundColor = notSelectedColor
                option3Btn.backgroundColor = notSelectedColor
                option4Btn.backgroundColor = notSelectedColor
            }
        }
    }

    @IBAction func option2Tap(_ sender: Any) {
        selectOption2(isUnitTest: false)
    }

    func selectOption2(isUnitTest: Bool) {
        if !isProcessingAnswer {
            selectedOption = selectedOption == 2 ? 0 : 2
            
            if !isUnitTest {
                option1Btn.backgroundColor = notSelectedColor
                option2Btn.backgroundColor = selectedOption == 2 ? selectedColor : notSelectedColor
                option3Btn.backgroundColor = notSelectedColor
                option4Btn.backgroundColor = notSelectedColor
            }
        }
    }

    @IBAction func option3Tap(_ sender: Any) {
        selectOption3(isUnitTest: false)
    }

    func selectOption3(isUnitTest: Bool) {
        if !isProcessingAnswer {
            selectedOption = selectedOption == 3 ? 0 : 3
            
            if !isUnitTest {
                option1Btn.backgroundColor = notSelectedColor
                option2Btn.backgroundColor = notSelectedColor
                option3Btn.backgroundColor = selectedOption == 3 ? selectedColor : notSelectedColor
                option4Btn.backgroundColor = notSelectedColor
            }
        }
    }
    
    @IBAction func option4Tap(_ sender: Any) {
        selectOption4(isUnitTest: false)
    }
    
    func selectOption4(isUnitTest: Bool) {
        if !isProcessingAnswer {
            selectedOption = selectedOption == 4 ? 0 : 4
            
            if !isUnitTest {
                option1Btn.backgroundColor = notSelectedColor
                option2Btn.backgroundColor = notSelectedColor
                option3Btn.backgroundColor = notSelectedColor
                option4Btn.backgroundColor = selectedOption == 4 ? selectedColor : notSelectedColor
            }
        }
    }
    
    // MARK: - Answer actions

    @IBAction func answerBtnTap(_ sender: Any) {
        answerTap()
    }

    func answerTap() {
        isProcessingAnswer = true
        
        guard selectedOption > 0,
              let quiz = self.quiz,
              let question = quiz.currentQuestion else {
            isProcessingAnswer = false
            
            let alert = UIAlertController(title: "Please choose an answer.",
                                          message: nil,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok!", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        self.isCorrectAnswer = question.correctIndex == selectedOption - 1
        quiz.correctAnswersCount += isCorrectAnswer ? 1 : 0
        
        let alert = UIAlertController(title: isCorrectAnswer ? "Correct :)" : "Wrong :(",
                                      message: nil,
                                      preferredStyle: .alert)
        let nextAction = UIAlertAction(title: quiz.questionIndex == quiz.questions.count
                                        ? "Results" : "Next",
                                      style: .default,
                                      handler: { _ in
                                        
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        if quiz.questionIndex == quiz.questions.count,
                                           let vc = storyboard.instantiateViewController(identifier: "ResultsVC") as? ResultsVC {
                                            
                                            vc.quiz = quiz
                                            vc.modalPresentationStyle = .fullScreen
                                            vc.modalTransitionStyle = .coverVertical
                                            self.present(vc, animated: true, completion: nil)
                                            
                                        } else if let vc = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController {
                                            
                                            vc.quiz = quiz
                                            vc.modalPresentationStyle = .fullScreen
                                            vc.modalTransitionStyle = .flipHorizontal
                                            self.present(vc, animated: true, completion: nil)
                                            
                                        }
        })
        
        alert.addAction(nextAction)
        self.present(alert, animated: true, completion: nil)
        
        isProcessingAnswer = false
    }

    func answerIsCorrect() {
        isProcessingAnswer = false
        isCorrectAnswer = true

        selectedOption = 0
    }

    func answerIsWrong() {
        isProcessingAnswer = false
        isCorrectAnswer = false

        selectedOption = 0
    }
}
