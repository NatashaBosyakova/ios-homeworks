//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Наталья Босякова on 27.11.2022.
//

import Foundation

final class ProfileCoordinator: AppCoordinator {

    private weak var transitionHandler: StackBasedNavigation?
    
    var childs: [AppCoordinator] = []
    
    init(transitionHandler: StackBasedNavigation?) {
        self.transitionHandler = transitionHandler
    }
    
    func start(user: User?) {
        showProfileScreen(user: user)
    }
    
    fileprivate func showProfileScreen(user: User?) {
        let controller = ProfileViewController()
        controller.user = user
        transitionHandler?.push(controller, animated: true)
    }
}
