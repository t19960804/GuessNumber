//
//  RegulationHandle.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/9/30.
//  Copyright © 2018 t19960804. All rights reserved.
//

import Foundation
import GameKit
struct RegulationHandle {
    var numberArray : [Int] = [1,2,3,4]
    var randomArray : [Int] = []
    var inputArray : [Int] = []
    var right : Int = 0
    var wrong : Int = 0
    
    mutating func noRepeatNumbers()
    {
        
        for i in  0...numberArray.count - 1
        {
            let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: numberArray.count)
            randomArray.append(numberArray[randomNumber])
            numberArray.remove(at: randomNumber)
            print("random:",randomArray[i])
            
        }
    }
    func checkEachNumber(Index index : Int ) -> Bool
    {
        //兩個陣列裡對應到的index相比較
        if inputArray[index] == randomArray[index]{
            return true
        }else{
            return false
        }
    }
    mutating func resumeArrays(){
        randomArray.removeAll()
        inputArray.removeAll()
        numberArray = [1,2,3,4]
        noRepeatNumbers()
    }
    mutating func checkNumberIsCorrect(){
        
            for i in 0...3
            {
                if checkEachNumber(Index: i) == true{
                    right += 1
                }else{
                    wrong += 1
                    
                }
            }
        
    }
}
