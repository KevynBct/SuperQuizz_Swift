//
//  APIClient.swift
//  SuperQuizz
//
//  Created by formation9 on 06/12/2018.
//  Copyright © 2018 formation9. All rights reserved.
//
import Foundation

class APIClient {
    private let QUESTION_ID = "id"
    private let TITLE = "title"
    private let ANSWER_1 = "answer_1"
    private let ANSWER_2 = "answer_2"
    private let ANSWER_3 = "answer_3"
    private let ANSWER_4 = "answer_4"
    private let CORRECT_ANSWER = "correct_answer"
    private let AUTHOR = "author"
    private let urlServerAddress = "http://192.168.10.204:3000/questions"
    static let instance = APIClient()
    
    private init(){
        
    }
    
    func getAllQuestionsFromServer(onSuccess: @escaping ([Question]) -> (), onError: @escaping (Error) -> ()) -> URLSessionTask {
        
        var request = URLRequest(url: URL(string: urlServerAddress)! )
        request.httpMethod = "GET"
        
        // Préparation de la tâche de telechargement des données
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Si j'ai des données
            if let data = data {
                
                
                // Je la transforme en Array
                let dataArray = try! JSONSerialization.jsonObject(with: data, options: []) as! [Any]
                var questionsToreturn = [Question]()
                // Pour chaque objet dans l'array
                for object in dataArray {
                    
                    let objectDictionary = object as! [String:Any]
                    let q  = Question(objectDictionary[self.TITLE] as! String)
                    q.questionId = objectDictionary[self.QUESTION_ID] as? Int
                    q.addProposition(objectDictionary[self.ANSWER_1] as! String)
                    q.addProposition(objectDictionary[self.ANSWER_2] as! String)
                    q.addProposition(objectDictionary[self.ANSWER_3] as! String)
                    q.addProposition(objectDictionary[self.ANSWER_4] as! String)
                    let correctAnswer = objectDictionary[self.CORRECT_ANSWER] as? Int ?? -1
                    q.correctAnswer = q.getProposition(correctAnswer - 1)
                    
                    questionsToreturn.append(q)
                }
                onSuccess(questionsToreturn)
                
            } else  {
                onError(error!)
            }
        }
        // Lancement la tâche
        task.resume()
        
        // Renvoie la tâche pour pouvoir l'annuler
        return task
    }
    
    func postQuestionOnServer(questionToAdd : Question, onSuccess: @escaping () -> (), onError: @escaping (Error) -> ())  -> URLSessionTask {
        let json : [String: Any] = [self.TITLE : questionToAdd.questionTitle,
                                    self.ANSWER_1 : questionToAdd.getProposition(0),
                                    self.ANSWER_2 : questionToAdd.getProposition(1),
                                    self.ANSWER_3 : questionToAdd.getProposition(2),
                                    self.ANSWER_4 : questionToAdd.getProposition(3),
                                    self.ANSWER_4 : questionToAdd.getCorrectAnswerIndex() + 1,
                                    self.AUTHOR : "Kevyn"]
        
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: URL(string: urlServerAddress)! )
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if data != nil {
                 onSuccess()
            }else  {
                onError(error!)
            }
        }
        task.resume()
        
        return task
    }
}
