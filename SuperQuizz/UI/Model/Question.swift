//
//  Question.swift
//  SuperQuizz
//
//  Created by formation9 on 04/12/2018.
//  Copyright © 2018 formation9. All rights reserved.
//

class Question {
    var questionId : Int?
    var questionTitle : String
    var propositions = [String]()
    var correctAnswer : String?
    
    init(_ questionTitle : String) {
        self.questionTitle = questionTitle
    }
    
    func addProposition(_ proposition : String){
        self.propositions.append(proposition)
    }
    
    func getProposition(_ index : Int) -> String {
        return self.propositions[index]
    }
    
    func setProposition( index : Int, proposition : String){
        self.propositions[index] = proposition
    }
    
    func isCorrectAnswer(answer : String) -> Bool {
        if answer == correctAnswer{
            return true
        }else{
            return false
        }
    }
    
}
