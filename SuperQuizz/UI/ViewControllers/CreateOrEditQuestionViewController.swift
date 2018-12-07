//
//  CreateOrEditQuestionViewController.swift
//  SuperQuizz
//
//  Created by formation9 on 05/12/2018.
//  Copyright © 2018 formation9. All rights reserved.
//

import UIKit

protocol CreateOrEditQuestionDelegate : AnyObject {
    func userDidEditQuestion(q : Question, index : Int) -> ()
    func userDidCreateQuestion(q : Question) -> ()
}

class CreateOrEditQuestionViewController: UIViewController{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var answer1TextField: UITextField!
    @IBOutlet weak var answer2TextField: UITextField!
    @IBOutlet weak var answer3TextField: UITextField!
    @IBOutlet weak var answer4TextField: UITextField!
    @IBOutlet weak var answer1SwitchButton: UISwitch!
    @IBOutlet weak var answer2SwitchButton: UISwitch!
    @IBOutlet weak var answer3SwitchButton: UISwitch!
    @IBOutlet weak var answer4SwitchButton: UISwitch!
    
    var questionToEdit: Question?
    var indexOfQuestionToEdit : Int?
    weak var delegate : CreateOrEditQuestionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if questionToEdit != nil {
            titleTextField.text = questionToEdit?.questionTitle
            answer1TextField.text = questionToEdit?.getProposition(0)
            answer2TextField.text = questionToEdit?.getProposition(1)
            answer3TextField.text = questionToEdit?.getProposition(2)
            answer4TextField.text = questionToEdit?.getProposition(3)
            initAnswerSwitchButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func createOrEditQuestion(_ sender: Any) {
        if !verifyTextFieldsAreNotEmpty(){
            return
        }
        if let question = questionToEdit {
            question.questionTitle = titleTextField.text ?? ""
            question.setProposition(index: 0, proposition: answer1TextField.text ?? "")
            question.setProposition(index: 1, proposition: answer2TextField.text ?? "")
            question.setProposition(index: 2, proposition: answer3TextField.text ?? "")
            question.setProposition(index: 3, proposition: answer4TextField.text ?? "")
            question.correctAnswer = getAnswerFromSwitchButtonSelected()
            
            delegate?.userDidEditQuestion(q: question, index : indexOfQuestionToEdit!)
        } else {
            let question = Question(titleTextField.text ?? "")
            question.addProposition(answer1TextField.text ?? "")
            question.addProposition(answer2TextField.text ?? "")
            question.addProposition(answer3TextField.text ?? "")
            question.addProposition(answer4TextField.text ?? "")
            question.correctAnswer = getAnswerFromSwitchButtonSelected()
            
            delegate?.userDidCreateQuestion(q: question)
        }
    }
    
    @IBAction func onAnswerSwitchButtonTap(_ sender: UISwitch) {
        resetAllAnswersSwitchButtons()
        sender.isOn = true
    }
    
    func resetAllAnswersSwitchButtons(){
        answer1SwitchButton.isOn = false
        answer2SwitchButton.isOn = false
        answer3SwitchButton.isOn = false
        answer4SwitchButton.isOn = false
    }
    
    func initAnswerSwitchButton(){
        resetAllAnswersSwitchButtons()
        switch questionToEdit?.correctAnswer {
        case questionToEdit?.getProposition(0):
            answer1SwitchButton.isOn = true
        case questionToEdit?.getProposition(1):
            answer2SwitchButton.isOn = true
        case questionToEdit?.getProposition(2):
            answer3SwitchButton.isOn = true
        default:
            answer4SwitchButton.isOn = true
        }
    }
    
    func getAnswerFromSwitchButtonSelected() -> String {
        if answer1SwitchButton.isOn {
            return answer1TextField.text ?? ""
        }else if answer2SwitchButton.isOn {
            return answer2TextField.text ?? ""
        }else if answer3SwitchButton.isOn {
            return answer3TextField.text ?? ""
        } else {
            return answer4TextField.text ?? ""
        }
    }
    
    func verifyTextFieldsAreNotEmpty() -> Bool {
        var isOk = true
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            answer1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            answer2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            answer3TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            answer4TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            isOk = false
        }
        
        if !isOk {
            let textFieldsAreNotOk = UIAlertController(title: "Erreur", message: "Un ou plusieurs champ(s) manquant(s) !", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            }
            textFieldsAreNotOk.addAction(action)
            self.present(textFieldsAreNotOk, animated: true, completion: nil)
        }
        
        return isOk
    }
    
    @IBAction func onCancelButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
