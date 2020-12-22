//
//  HomeVC.swift
//  quick-questions
//
//  Created by Francesco Prospato on 11/4/20.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var difficultyLbl: UILabel!
    @IBOutlet weak var difficultyBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    // MARK: - Variables
    
    public var numberOfQuestions = 1
    private var _category: QuizDatabaseHelper.Category = .generalKnowledge
    private var _difficulty: QuizDatabaseHelper.Difficulty = .easy
    
    // MARK: - View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _setupView()
    }

    private func _setupView() {
        titleLbl.text = "Quick Questions"
        titleLbl.font = UIFont.systemFont(ofSize: 34, weight: .black)
        titleLbl.textAlignment = .center
        titleLbl.numberOfLines = 0
        
        _setNumberOfQuestions()
        
        _setCategoryOption()
        
        _setDifficultyOption()
        
        continueBtn.setTitle("Start Quiz!", for: .normal)
        continueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        continueBtn.layer.cornerRadius = 10
    }
    
    private func _setNumberOfQuestions() {
        numberLbl.text = "Number of Questions"
        numberLbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        numberTF.delegate = self
        numberTF.text = "\(numberOfQuestions)"
        numberTF.textAlignment = .center
        numberTF.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        numberTF.borderStyle = .none
        numberTF.keyboardType = .numberPad
        numberTF.textColor = .systemBlue
        numberTF.accessibilityLabel = "Number of Questions"
    }
    
    private func _setCategoryOption() {
        categoryLbl.text = "Category"
        categoryLbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        var menuActions = [UIAction]()
        for category in QuizDatabaseHelper.Category.allCases {
            let action = UIAction(title: category.toString(), handler: { _ in
                self._category = category
                self.categoryBtn.setTitle(category.toString(), for: .normal)
            })
            menuActions.append(action)
        }
        
        categoryBtn.menu = UIMenu(title: "Category", children: menuActions)
        categoryBtn.showsMenuAsPrimaryAction = true
        
        categoryBtn.setTitle(_category.toString(), for: .normal)
        categoryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    private func _setDifficultyOption() {
        difficultyLbl.text = "Difficulty"
        difficultyLbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        let difficultyOption = UIMenu(title: "Difficulty", options: .displayInline, children: [
            UIAction(title: "Easy", handler: { _ in
                self._difficulty = .easy
                self.difficultyBtn.setTitle("Easy", for: .normal)
            }),
            UIAction(title: "Medium", handler: { _ in
                self._difficulty = .medium
                self.difficultyBtn.setTitle("Medium", for: .normal)
            }),
            UIAction(title: "Hard", handler: { _ in
                self._difficulty = .hard
                self.difficultyBtn.setTitle("Hard", for: .normal)
            }),
            UIAction(title: "Random", handler: { _ in
                self._difficulty = .random
                self.difficultyBtn.setTitle("Random", for: .normal)
            })
        ])
        
        difficultyBtn.menu = difficultyOption
        difficultyBtn.showsMenuAsPrimaryAction = true
        
        difficultyBtn.setTitle(_difficulty.rawValue, for: .normal)
        difficultyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    // MARK: - Continue
    
    @IBAction func continueBtnTap(_ sender: Any) {
        self.view.endEditing(true)
        
        if numberOfQuestions == 0 { return }
        
        QuizDatabaseHelper.getQuiz(numberOfQuestions: numberOfQuestions,
                                   category: _category,
                                   difficulty: _difficulty) { (quizResult) in
            DispatchQueue.main.async {
                if let quiz = quizResult,
                   let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as? ViewController {
                    vc.quiz = quiz
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .flipHorizontal
                    self.present(vc, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error starting quiz.",
                                                  message: "Please make sure you're connected to the internet and try again.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension HomeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if text == "" || text == "0" {
            let alert = UIAlertController(title: "Invalid number of questions",
                                          message: "You need at least one question to start the quiz.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            textField.text = "0"
            numberOfQuestions = 0
        } else if let numberOfQuestions = Int(text) {
            self.numberOfQuestions = numberOfQuestions
        }
    }
}
