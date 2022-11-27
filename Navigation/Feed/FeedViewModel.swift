//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Наталья Босякова on 24.11.2022.
//


final class FeedViewModel {
    
    let model: FeedModel
    
    init(model: FeedModel) {
        self.model = model
    }
    
    func check(_ word: String) -> Bool {
        return word == model.secretWord
    }
}
