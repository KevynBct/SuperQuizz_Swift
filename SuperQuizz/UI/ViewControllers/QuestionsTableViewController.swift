//
//  QuestionsTableViewController.swift
//  SuperQuizz
//
//  Created by formation9 on 04/12/2018.
//  Copyright © 2018 formation9. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
    var questionList = [Question]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Liste des questions"

        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionTableViewCell")
        
        let question1 = Question("Quel est la capitale de la France ?")
        question1.addProposition("Marseille")
        question1.addProposition("Nantes")
        question1.addProposition("Paris")
        question1.addProposition("Lyon")
        question1.correctAnswer = "Paris"
        
        let question2 = Question("Quel est la capitale de l'Espagne ?")
        question2.addProposition("Madrid")
        question2.addProposition("Bilbao")
        question2.addProposition("Barcelone")
        question2.addProposition("Valence")
        question2.correctAnswer = "Madrid"
        
        let question3 = Question("Quel est la capitale du Japon ?")
        question3.addProposition("Nara")
        question3.addProposition("Osaka")
        question3.addProposition("Kyoto")
        question3.addProposition("Tokyo")
        question3.correctAnswer = "Tokyo"
        
        questionList.append(question1)
        questionList.append(question2)
        questionList.append(question3)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        
        let question : Question = questionList[indexPath.row]
        
        cell.questionTitleLabel.text = "\(indexPath.row + 1)) \(question.questionTitle)"
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as? AnswerViewController else {
            return
        }
        
        controller.question = questionList[indexPath.row]
        
        controller.setOnReponseAnswered { (questionAnswered, result) in
            let wrongOrRightAnswer : String
            if result {
                wrongOrRightAnswer = "Bonne réponse !"
            }else{
                wrongOrRightAnswer = "Mauvaise réponse..."
            }
            let wrongOrRightAnswerController = UIAlertController(title: wrongOrRightAnswer, message: "La bonne réponse est \(questionAnswered.correctAnswer ?? "") ", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            wrongOrRightAnswerController.addAction(action)
            self.present(wrongOrRightAnswerController, animated: true, completion: nil)

        }
        
        self.show(controller, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            let deleteQuestion = NSLocalizedString("Delete", comment: "Delete question")
            let deleteAction = UITableViewRowAction(style: .destructive, title: deleteQuestion) { (action, indexPath) in
                self.questionList.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            
            let editQuestion = NSLocalizedString("Edit", comment: "Edit question")
            let editAction = UITableViewRowAction(style: .normal, title: editQuestion) { (action, indexPath) in
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateOrEditQuestionViewController") as? CreateOrEditQuestionViewController else {
                    return
                }
                
                controller.questionToEdit = self.questionList[indexPath.row]
                controller.indexOfQuestionToEdit = indexPath.row
                controller.delegate = self
                
                self.show(controller, sender: self)
            }
        
            return [editAction, deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreateOrEditViewController" {
            let controller = segue.destination as! CreateOrEditQuestionViewController
            controller.delegate = self
        }
    }
}

extension QuestionsTableViewController : CreateOrEditQuestionDelegate {
    func userDidEditQuestion(q: Question, index : Int) {
        questionList[index] = q
        self.tableView.reloadData()
//        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func userDidCreateQuestion(q: Question) {
        questionList.append(q)
        self.tableView.reloadData()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
