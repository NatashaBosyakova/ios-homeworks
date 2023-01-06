//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Наталья Босякова on 22.08.2022.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var rootCoordinator: AppCoordinator?
    
    var appConfigaration: AppConfiguration = AppConfiguration.random()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        
        /*
        
        let feed = UINavigationController()
        let profile = UINavigationController()

        let feedViewController = FeedViewController()
        let logInViewController = LogInViewController()
        logInViewController.loginDelegate = MyLoginFactory().makeLoginInspector()
                
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [feed, profile]
        UITabBar.appearance().tintColor = UIColor(named: "color")
        UITabBar.appearance().backgroundColor = .systemGray6
        UITabBar.appearance().barTintColor = .systemGray3
        
        tabBarController.tabBar.layer.borderWidth = 1
        tabBarController.tabBar.layer.borderColor = UIColor.systemGray4.cgColor

        feed.tabBarItem.title = "Feed"
        feed.tabBarItem.image = UIImage(systemName: "house.fill")
        
        profile.tabBarItem.title = "Profile"
        profile.tabBarItem.image = UIImage(systemName: "person.fill")
        
        feed.viewControllers.append(feedViewController)
        profile.viewControllers.append(logInViewController)
   
        self.window?.rootViewController = tabBarController
         
        */
        
        let navigationController = UINavigationController()
        let coordinator = RootCoordinator(transitionHandler: navigationController)
        self.window?.rootViewController = coordinator.start()
        
        self.window?.makeKeyAndVisible()
        
        NetworkService.request(for: appConfigaration)
        
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
        do {
            try Auth.auth().signOut()
        }
        catch{
            print("Signing Out Error!")
        }
        
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

