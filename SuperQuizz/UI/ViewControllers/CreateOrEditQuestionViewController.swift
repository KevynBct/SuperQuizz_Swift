//
//  CreateOrEditQuestionViewController.swift
//  SuperQuizz
//
//  Created by formation9 on 05/12/2018.
//  Copyright © 2018 formation9. All rights reserved.
//

import UIKit

protocol CreateOrEditQuestionDelegate : AnyObject {
    func userDidEditQuestion(q : Question) -> ()
    func userDidCreateQuestion(q : Question) -> ()
}

class CreateOrEditQuestionViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var answer1TextField: UITextField!
    @IBOutlet weak var answer2TextField: UITextField!
    @IBOutlet weak var answer3TextField: UITextField!
    @IBOutlet weak var answer4TextField: UITextField!
    @IBOutlet weak var correctAnswerTextField: UITextField!
    
    var questionToEdit: Question?
    weak var delegate : CreateOrEditQuestionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if questionToEdit != nil {
            titleTextField.text = questionToEdit?.questionTitle
            answer1TextField.text = questionToEdit?.getProposition(0)
            answer2TextField.text = questionToEdit?.getProposition(1)
            answer3TextField.text = questionToEdit?.getProposition(2)
            answer4TextField.text = questionToEdit?.getProposition(3)
            correctAnswerTextField.text = questionToEdit?.correctAnswer
        }
    }
    
    @IBAction func createOrEditQuestion(_ sender: Any) {
        if let question = questionToEdit {
            question.questionTitle = titleTextField.text ?? ""
            question.setProposition(index: 0, proposition: answer1TextField.text ?? "")
            question.setProposition(index: 1, proposition: answer2TextField.text ?? "")
            question.setProposition(index: 2, proposition: answer3TextField.text ?? "")
            question.setProposition(index: 3, proposition: answer4TextField.text ?? "")
            question.correctAnswer = correctAnswerTextField.text ?? ""            
            
            delegate?.userDidEditQuestion(q: question)
        } else {
            let question = Question(titleTextField.text ?? "")
            question.addProposition(answer1TextField.text ?? "")
            question.addProposition(answer2TextField.text ?? "")
            question.addProposition(answer3TextField.text ?? "")
            question.addProposition(answer4TextField.text ?? "")
            question.correctAnswer = correctAnswerTextField.text ?? ""
            
            delegate?.userDidCreateQuestion(q: question)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
