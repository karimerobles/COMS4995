//
//  ResultsVC.swift
//  quick-questions
//
//  Created by Francesco Prospato on 11/4/20.
//

import UIKit

class ResultsVC: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var resultsLbl: UILabel!
    @IBOutlet weak var highScoreLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    var quiz: Quiz?
    
    // MARK: - View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupView()
    }
    
    private func _setupView() {
        titleLbl.text = "Your Results"
        titleLbl.font = UIFont.systemFont(ofSize: 30, weight: .black)
        titleLbl.textAlignment = .center
        titleLbl.numberOfLines = 0
        
        continueBtn.setTitle("Home", for: .normal)
        continueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        continueBtn.layer.cornerRadius = 10
        
        guard let quiz = quiz else { return }
        let newScore = quiz.correctAnswersCount * 100
        resultsLbl.text = "Your score: \(newScore)!"
        resultsLbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        resultsLbl.textAlignment = .center
        resultsLbl.numberOfLines = 0
        
        highScoreLbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        highScoreLbl.textAlignment = .center
        highScoreLbl.numberOfLines = 0
        let defaults = UserDefaults.standard
        let currentHighScore = defaults.integer(forKey: "HighScore")
        if newScore > currentHighScore {
            defaults.set(newScore, forKey: "HighScore")
            highScoreLbl.text = "NEW high score!"
        } else if newScore == currentHighScore {
            highScoreLbl.text = ""
        } else {
            highScoreLbl.text = "Try better next time! Your high score: \(currentHighScore)"
        }
    }
    
    @IBAction func continueBtnTap(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main",
                                    bundle: nil).instantiateViewController(identifier: "HomeVC") as? HomeVC else { return }
            
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .partialCurl
        self.present(vc, animated: true, completion: nil)
    }
}
