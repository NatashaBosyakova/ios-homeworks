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
    func getUser(login: String) throws -> User?
}

class CurrentUserService: UserService {
    
    let users: [User] =
        [
        User(login: "Natasha", fullName: "Natasha Bosyakova", avatar: UIImage(named: "ProfileImage")!, status: "learning iOS"),
        User(login: "Anastasia", fullName: "Anastasia Bosyakova", status: "relocating"),
        User(login: "Pavel", fullName: "Pavel Zykin", status: "-"),
       ]
    
    var user: User? = nil    
    
    func getUser(login: String) throws -> User? {
        if let user = users.first(where: {$0.login == login}) {
            return user
        }
        else {
            throw MyError.invalidLogin
        }
    }
}

class TestUserService: UserService {
        
    var user: User? = nil
    
    func getUser(login: String) throws -> User? {
        return User(login: "Test", fullName: "Test User", status: "no status")
    }
}

class Checker {
    
    static let shared: Checker = {
        return Checker()
    }()
    
    private let login: String = {return "Natasha"}()
    private let password: String = {return "1234"}()

    private init() {
        
    }
    
    func check(login: String, password: String) -> Bool {
        return self.login == login && self.password == password
    }
}

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}

struct LoginInspector: LoginViewControllerDelegate {
    
    func check(login: String, password: String) -> Bool {
        let checker = Checker.shared
        return checker.check(login: login, password: password)
    }
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}