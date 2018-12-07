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
    @IBOutlet weak var questionProgressView: UIProgressView!
    var buttonsList : [UIButton]?
    @IBOutlet weak var questionImageView: UIImageView!
    var onQuestionAnswered : ((_ question : Question, _ userAnswer : String) -> ())?
    var work : DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerQuestionLabel.text = question.questionTitle
        
        buttonsList = [answer1, answer2, answer3, answer4]
        
        answer1.setTitle(question.getProposition(0), for: .normal)
        answer2.setTitle(question.getProposition(1), for: .normal)
        answer3.setTitle(question.getProposition(2), for: .normal)
        answer4.setTitle(question.getProposition(3), for: .normal)
        
        loadImageFromUrl()
        
        if let userAnswer = question.userAnswer{
            disableAllButtons(userAnswer)
            self.questionProgressView.progress = 0.0
        }else{
            work = DispatchWorkItem{
                var count = 1.0
                while (count > 0){
                    if (self.work?.isCancelled ?? false){
                        return;
                    }
                    Thread.sleep(forTimeInterval: 0.04)
                    count = count - 0.01
                    DispatchQueue.main.async {
                        self.questionProgressView.progress = Float(count)
                    }
                }
                DispatchQueue.main.async {
                    self.disableAllButtons("")
                    self.onQuestionAnswered?(self.question, "")
                }
            }
            DispatchQueue.global(qos : .userInitiated).async(execute: work!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        work?.cancel()
    }
    
    func loadImageFromUrl(){
        guard let imageUrl = question.imageUrl else{return}
        guard let url = URL(string: imageUrl) else {return}
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.questionImageView.image = UIImage(data: data)
            }
        }
    }
    
    func disableAllButtons(_ userAnswer : String){
        UIView.animate(withDuration: 1) {
            for button in self.buttonsList!{
                button.isEnabled = false
                if(button.titleLabel!.text == userAnswer){
                    if(self.question.correctAnswer ==  userAnswer){
                        button.backgroundColor = UIColor(red:0.41, green:0.94, blue:0.68, alpha:1.0)
                        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
                    }else{
                        button.backgroundColor = UIColor.red
                        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
                    }
                }
            }
        }
    }

    @IBAction func onButtonAnswerTap(_ sender: UIButton) {
        work?.cancel()
        let userAnswer = sender.titleLabel?.text ?? ""
        
        self.disableAllButtons(userAnswer)
        
        onQuestionAnswered?(question, userAnswer)
    }
    
    func setOnReponseAnswered(closure : @escaping (_ question: Question, _ userAnswer : String)->()) {
        onQuestionAnswered = closure
    }
}

