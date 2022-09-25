//
//  Post.swift
//  Navigation
//
//  Created by Наталья Босякова on 22.09.2022.
//

import Foundation
import UIKit

struct Post {
    let author: String
    let description: String
    let image: String
    let likes: Int
    let views: Int
    
    init(index: Int) {
        
        let authors = ["Alice", "Bob", "Carol", "Dave"]
        let descriptions = [
            "the best day",
            "Vacation 2024. Исследования установили, что даже ожидание отпуска делает человека счастливее и повышает производительность труда. Связано это с тем, что в предвкушении отдыха специалист становится более стрессоустойчивым и собранным. Работа без отпуска накапливает стресс и хроническую усталость.",
            "Dave's party",
            "~ ♡ ~"]
        
        self.author = authors[index]
        self.description = descriptions[index]
        self.image = "PostImage"+String(index)
        self.likes = Int.random(in: 1...1000)
        self.views = Int.random(in: 1...10000)
    }
}
