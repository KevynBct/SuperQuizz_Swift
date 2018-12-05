//
//  ViewController.swift
//  SuperQuizz
//
//  Created by formation9 on 04/12/2018.
//  Copyright © 2018 formation9. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    var question : Question!
    @IBOutlet weak var answerQuestionLabel: UILabel!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    var onQuestionAnswered : ((_ question : Question, _ isCorrectAnswer : Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerQuestionLabel.text = question.questionTitle
        
        answer1.setTitle(question.getProposition(0), for: .normal)
        answer2.setTitle(question.getProposition(1), for: .normal)
        answer3.setTitle(question.getProposition(2), for: .normal)
        answer4.setTitle(question.getProposition(3), for: .normal)
    }

    @IBAction func onButtonAnswerTap(_ sender: UIButton) {
        onQuestionAnswered?(question, question.isCorrectAnswer(answer: sender.titleLabel?.text ?? ""))
    }
    
    func setOnReponseAnswered(closure : @escaping (_ question: Question,_ isCorrectAnswer :Bool)->()) {
        onQuestionAnswered = closure
    }    
}

