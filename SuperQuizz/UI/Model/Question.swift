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
    var userAnswer : String?
    
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
    
    func getCorrectAnswerIndex() -> Int {
        switch correctAnswer {
        case getProposition(0):
            return 0
        case getProposition(0):
            return 1
        case getProposition(0):
            return 2
        default:
            return 3
        }
    }
    
    func isCorrectAnswer(answer : String) -> Bool {
        if answer == correctAnswer{
            return true
        }else{
            return false
        }
    }
}
