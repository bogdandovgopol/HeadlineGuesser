//
//  QuestionResponseVC.swift
//  HeadlineGuesser
//
//  Created by Bogdan on 25/8/20.
//  Copyright © 2020 Bogdan. All rights reserved.
//

import UIKit

class QuestionResponseVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var feedbackTxt: UILabel!
    @IBOutlet weak var scoreTxt: UILabel!
    @IBOutlet weak var correctAnswerTxt: UILabel!
    
    //MARK: Variables
    weak var quizDelegate: QuizDelegate?
    
    var question: Question!
    var score: Int!
    var isCorrectAnswer: Bool!
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // MARK: UI
    func updateUI() {
        DispatchQueue.main.async {
            if self.isCorrectAnswer {
                self.feedbackTxt.text = "Correct answer!"
            } else {
                self.feedbackTxt.text = "Wrong answer!"
            }
            self.scoreTxt.text = "Your score is \(String(self.score))"
            self.correctAnswerTxt.text = self.question.headlines[self.question.correctAnswerIndex]
        }
    }
    
    // MARK: Buttons implementation
    @IBAction func onReadArticlePressed(_ sender: Any) {
        UIApplication.shared.open(question.storyUrl)
    }
    
    @IBAction func onNextQuestionPressed(_ sender: Any) {
        quizDelegate?.onContinue()
        dismiss(animated: false, completion: nil)
    }
    
}
