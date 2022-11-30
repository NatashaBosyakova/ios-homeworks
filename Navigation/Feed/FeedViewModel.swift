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
    
    func check(_ word: String) -> Result<Bool, MyError> { // Собственные домены ошибок. Управление ошибками приложения / задача 3.
        if (word.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return .failure(MyError.emptyData)
        }
        else {
            return .success(word == model.secretWord)
        }
    }
}
