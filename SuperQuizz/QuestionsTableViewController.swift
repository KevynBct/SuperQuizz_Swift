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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        
        self.show(controller, sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
