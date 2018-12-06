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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let _ = APIClient.instance.getAllQuestionsFromServer(onSuccess: { (questionsListFromServer) in
            if(self.questionList.count == 0){
                self.questionList = questionsListFromServer
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
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
        
        cell.questionTitleLabel.text = "\(indexPath.row + 1) - \(question.questionTitle)"
        
        
        if(question.userAnswer != nil){
            if(question.isCorrectAnswer(answer: question.userAnswer!)){
                cell.questionTitleLabel.textColor = UIColor.green
            }else{
                cell.questionTitleLabel.textColor = UIColor.red
            }
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnswerViewController") as? AnswerViewController else {
            return
        }
        
        controller.question = questionList[indexPath.row]
        
        controller.setOnReponseAnswered { (questionAnswered, userAnswer) in
            let wrongOrRightAnswer : String
            let result = questionAnswered.isCorrectAnswer(answer: userAnswer)
            if result{
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
            
            self.questionList[indexPath.row].userAnswer = userAnswer
            self.tableView.reloadData()
        }
        
        self.show(controller, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            let deleteQuestion = NSLocalizedString("Delete", comment: "Delete question")
            let deleteAction = UITableViewRowAction(style: .destructive, title: deleteQuestion) { (action, indexPath) in
                let confirmToDeleteAlertController = UIAlertController(title: "Confirmation", message: "Voulez vous vraiment supprimer cette question ?", preferredStyle: .alert)
                
                let actionOk = UIAlertAction(title: "Oui", style: .default) { (action:UIAlertAction) in
                    self.questionList.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                
                let actionCancel = UIAlertAction(title: "Non", style: .cancel, handler: { (action:UIAlertAction) in
                })
                
                confirmToDeleteAlertController.addAction(actionOk)
                confirmToDeleteAlertController.addAction(actionCancel)
                
                self.present(confirmToDeleteAlertController, animated: true, completion: nil)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func userDidCreateQuestion(q: Question) {
        questionList.append(q)
        APIClient.instance.postQuestionOnServer(questionToAdd: q, onSuccess: {
            print("Question ajoutée")
        }) { (error) in
            print(error)
        }
        self.tableView.reloadData()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
