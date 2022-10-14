//
//  User.swift
//  Navigation
//
//  Created by Наталья Босякова on 14.10.2022.
//



import UIKit

class User {
    var login: String
    var fullName: String
    var avatar: UIImage
    var status: String
    
    init (login: String, fullName: String = "-", avatar: UIImage = UIImage(systemName: "person.fill")!, status: String = "not defined") {
        
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

protocol UserService {
    func getUser(login: String) -> User?
}

class CurrentUserService: UserService {
    
    let users: [User] = [User(login: "Natasha", fullName: "Natasha Bosyakova", avatar: UIImage(named: "ProfileImage")!, status: "learning iOS"), User(login: "Anastasia", fullName: "Anastasia Bosyakova", status: "relocating")]
    
    var user: User? = nil    
    
    func getUser(login: String) -> User? {
        if let user = users.first(where: {$0.login == login}) {
            return user
        }
        else {
            return nil
        }
    }
}

class TestUserService: UserService {
        
    var user: User? = nil
    
    func getUser(login: String) -> User? {
        return User(login: "Test", fullName: "Test User", status: "no status")
    }
}

