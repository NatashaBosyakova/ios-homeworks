//
//  User.swift
//  Navigation
//
//  Created by Наталья Босякова on 14.10.2022.
//

import UIKit
import FirebaseAuth
import RealmSwift

class CurrentUserAutorization: Object {
    
    @Persisted(primaryKey: true) var _id: String
    @Persisted var login: String
    @Persisted var password: String
    
    convenience init(login: String, password: String) {
        self.init()
        self._id = "currentUserAutorization"
        self.login = login
        self.password = password
    }
}

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
    
    func checkCredentials(login: String, password: String) {
        Auth.auth().signIn(withEmail: login, password: password) {authResult, error in
                              
            guard error == nil else {
                
                //presentAlert(title: "", message: error!.localizedDescription, controller: UIViewController)
                
                return
           }
        }
    }
}

protocol LoginViewControllerDelegate : AnyObject {
    func check(login: String, password: String) -> Bool
    func checkCredentials(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ errorDescription: String) -> Void)
    func signUp(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ errorDescription: String) -> Void)
}

class LoginInspector: LoginViewControllerDelegate {
    
    func check(login: String, password: String) -> Bool {
        let checker = Checker.shared
        return checker.check(login: login, password: password)
    }
    
    func checkCredentials(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ errorDescription: String) -> Void) {
        CheckerService().checkCredentials(login: login, password: password, completionBlock: completionBlock)
    }
    
    func signUp(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ errorDescription: String) -> Void) {
        CheckerService().signUp(login: login, password: password, completionBlock: completionBlock)
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

protocol CheckerServiceProtocol {
    func checkCredentials(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ errorDescription: String) -> Void)
    func signUp(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ errorDescription: String) -> Void)
}

class CheckerService: CheckerServiceProtocol {
    
    func checkCredentials(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ errorDescription: String) -> Void) {
        Auth.auth().signIn(withEmail: login, password: password) {result, error in
            if let error {
                completionBlock(false, error.localizedDescription)
            } else {
                completionBlock(true, "")
            }
        }
    }
    
    func checkPassword(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ login: String, _ password: String) -> Void) {
        Auth.auth().signIn(withEmail: login, password: password) {result, error in
            if let _ = error {
                completionBlock(false, login, password)
            } else {
                completionBlock(true, login, password)
            }
        }
    }
    
    func signUp(login: String, password: String, completionBlock: @escaping (_ success: Bool, _ errorDescription: String) -> Void) {
        Auth.auth().createUser(withEmail: login, password: password) {result, error in
            if let error {
                completionBlock(false, error.localizedDescription)
            } else {
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = "User: "+login
                    changeRequest.photoURL = URL(string: "https://cdn-icons-png.flaticon.com/512/3468/3468094.png")
                    changeRequest.commitChanges { error in
                        if let error {
                            completionBlock(false, error.localizedDescription)
                        } else {
                            Auth.auth().signIn(withEmail: login, password: password) {result, error in
                                if let error {
                                    completionBlock(false, error.localizedDescription)
                                } else {
                                    completionBlock(true, "")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
