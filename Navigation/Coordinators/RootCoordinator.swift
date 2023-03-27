//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Наталья Босякова on 22.11.2022.
//

import Foundation
import UIKit

protocol AppCoordinator {
    var childs: [AppCoordinator] {get set}
}

final class RootCoordinator: AppCoordinator {
    private weak var transitionHandler: StackBasedNavigation?
    
    var childs: [AppCoordinator] = []
    
    init(transitionHandler: StackBasedNavigation) {
        self.transitionHandler = transitionHandler
    }
    
    func start() -> UIViewController {
        return TabBarController()
    }
    
}

class TabBarController: UITabBarController {

    private let navigationControllers: [UINavigationController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor(named: "color")
        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemGray3
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.systemGray4.cgColor
    
        self.viewControllers = []
        
        addController(
            controller: FeedViewController(),
            title: "Feed",
            image: UIImage(systemName: "house.fill")!)
        
        let logInViewController = LogInViewController()

        addController(
            controller: logInViewController,
            title: "Profile",
            image: UIImage(systemName: "person.fill")!)
        
        addController(
            controller: FavoritesViewController(),
            title: "Favorites",
            image: UIImage(systemName: "heart.text.square.fill")!)
    }

    func addController(controller: UIViewController, title: String, image: UIImage) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.viewControllers.append(controller)
        
        if self.viewControllers == nil {
            self.viewControllers = [navigationController]
        }
        else {
            self.viewControllers!.append(navigationController)
        }
    }
    
}
