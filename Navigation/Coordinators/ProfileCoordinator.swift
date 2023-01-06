//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Наталья Босякова on 27.11.2022.
//

import Foundation
import FirebaseAuth

final class ProfileCoordinator: AppCoordinator {

    private weak var transitionHandler: StackBasedNavigation?
    
    var childs: [AppCoordinator] = []
    
    init(transitionHandler: StackBasedNavigation?) {
        self.transitionHandler = transitionHandler
    }
    
    func start(user: FirebaseAuth.User?) {
        showProfileScreen(user: user)
    }
    
    fileprivate func showProfileScreen(user: FirebaseAuth.User?) {
        let controller = ProfileViewController()
        controller.user = user
        transitionHandler?.push(controller, animated: true)
    }
}
