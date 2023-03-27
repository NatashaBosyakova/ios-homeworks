//
//  Post.swift
//  Navigation
//
//  Created by Наталья Босякова on 22.09.2022.
//

import Foundation
import UIKit

public struct Post2 {
    public let id: Int16
    public let author: String
    public let description: String
    public let image: String
    public var likes: Int
    public var views: Int
    public var isFavorite: Bool /*{
        get {
            return Bool.random()
        }
    }*/
    
    public init(index: Int) {
        
        let ids = [1, 2, 3, 4]
        let authors = ["Alice", "Bob", "Carol", "Dave"]
        let descriptions = [
            "the best day",
            "Vacation 2024. Исследования установили, что даже ожидание отпуска делает человека счастливее и повышает производительность труда. Связано это с тем, что в предвкушении отдыха специалист становится более стрессоустойчивым и собранным. Работа без отпуска накапливает стресс и хроническую усталость.",
            "Dave's party",
            "~ ♡ ~"]
        
        self.id = Int16(ids[index])
        self.author = authors[index]
        self.description = descriptions[index]
        self.image = "PostImage"+String(index)
        self.likes = 0
        self.views = 0
        self.isFavorite = Bool.random()
    }
    

}
