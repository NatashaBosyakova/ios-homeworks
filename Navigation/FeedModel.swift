//
//  FeedModel.swift
//  Navigation
//
//  Created by Наталья Босякова on 21.11.2022.
//

import Foundation

class FeedModel {
    let secretWord: String = "Snail"
    
    func check(_ word: String) -> Bool {
        return word == secretWord
    }
}
