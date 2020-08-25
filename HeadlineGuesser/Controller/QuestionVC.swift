//
//  QuestionVC.swift
//  HeadlineGuesser
//
//  Created by Bogdan on 25/8/20.
//  Copyright © 2020 Bogdan. All rights reserved.
//

import UIKit
import Kingfisher

protocol QuizDelegate: class {
    func onContinue()
}

class QuestionVC: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var questionImg: UIImageView!
    
    @IBOutlet weak var answerOneView: UIView!
    @IBOutlet weak var answerTwoView: UIView!
    @IBOutlet weak var answerThreeView: UIView!
    @IBOutlet weak var answersStackView: UIStackView!
    
    @IBOutlet weak var standFirstTxt: UILabel!
    @IBOutlet weak var answerOneTxt: UILabel!
    @IBOutlet weak var answerTwoTxt: UILabel!
    @IBOutlet weak var answerThreeTxt: UILabel!
    @IBOutlet weak var victoryTxt: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Variables
    var quizDelegate = self
    
    var questions = [Question]()
    var currentQuestionIndex = 0
    var currentQuestion: Question!
    
    var isCorrectAnswer: Bool!
    var score = 0
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestions()
        registerGestures()
    }
    
    func registerGestures() {
        let answerOneTap = UITapGestureRecognizer(target: self, action: #selector(self.onAnswerOneTap(_:)))
        answerOneView.addGestureRecognizer(answerOneTap)
        
        let answerTwoTap = UITapGestureRecognizer(target: self, action: #selector(self.onAnswerTwoTap(_:)))
        answerTwoView.addGestureRecognizer(answerTwoTap)
        
        let answerThreeTap = UITapGestureRecognizer(target: self, action: #selector(self.onAnswerThreeTap(_:)))
        answerThreeView.addGestureRecognizer(answerThreeTap)
    }
    
    
    // MARK: Loading questions
    func loadQuestions() {
        activityIndicator.startAnimating()
        QuestionService.shared.getQuestions { [weak self](result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.failure(let error):
                    debugPrint(error.localizedDescription)
                    self.presentSimpleAlert(title: nil, message: error.rawValue, buttonTitle: "Try again")
                case .success(let questions):
                    self.questions.append(contentsOf: questions)
                    self.currentQuestion = questions[self.currentQuestionIndex]
                    self.updateUI(currentQuestion: questions[self.currentQuestionIndex])
                }
                self.activityIndicator.stopAnimating()
                self.answersStackView.isHidden = false
            }
        }
    }
    
    func presentSimpleAlert(title: String?, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { _ in
            self.loadQuestions()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UI
    func updateUI(currentQuestion: Question) {
        DispatchQueue.main.async {
            self.questionImg.kf.setImage(with: currentQuestion.imageUrl)
            self.standFirstTxt.text = currentQuestion.standFirst
            
            self.answerOneTxt.text = currentQuestion.headlines[0]
            self.answerTwoTxt.text = currentQuestion.headlines[1]
            self.answerThreeTxt.text = currentQuestion.headlines[2]
        }
    }
    
    // MARK: Buttons implementation
    @objc func onAnswerOneTap(_ sender: UITapGestureRecognizer) {
        checkIfAnsweredCorrectly(answerIndex: 0)
    }
    
    @objc func onAnswerTwoTap(_ sender: UITapGestureRecognizer) {
        checkIfAnsweredCorrectly(answerIndex: 1)
    }
    
    @objc func onAnswerThreeTap(_ sender: UITapGestureRecognizer) {
        checkIfAnsweredCorrectly(answerIndex: 2)
    }
    
    @IBAction func onSkipAnswerPressed(_ sender: Any) {
        nextQuestion()
    }
    
    func showVictoryText() {
        questionImg.isHidden = true
        standFirstTxt.isHidden = true
        answersStackView.isHidden = true
        victoryTxt.isHidden = false
        victoryTxt.text = "You've answered all the questions. Your score is \(String(score))"
    }
    
    
    // MARK: Game logic
    func checkIfAnsweredCorrectly(answerIndex: Int) {
        if currentQuestion.correctAnswerIndex == answerIndex {
            isCorrectAnswer = true
            score += 1
        } else {
            isCorrectAnswer = false
        }
        
        performSegue(withIdentifier: Constants.Segues.ToQuestionResponseVC, sender: self)
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        
        //check if in range
        if currentQuestionIndex <= questions.count {
            currentQuestion = questions[self.currentQuestionIndex]
            updateUI(currentQuestion: currentQuestion)
        } else {
            showVictoryText()
        }
    }
    
    // MARK: Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ToQuestionResponseVC {
            if let destination = segue.destination as? QuestionResponseVC {
                destination.quizDelegate = self
                destination.question = currentQuestion
                destination.score = score
                destination.isCorrectAnswer = isCorrectAnswer
            }
        }
    }
}

//MARK: QuizDelegate implementation
extension QuestionVC: QuizDelegate {
    func onContinue() {
        nextQuestion()
    }
}

