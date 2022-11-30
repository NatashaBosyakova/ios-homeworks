//
//  StackBasedNavigation.swift
//  Navigation
//
//  Created by Наталья Босякова on 27.11.2022.
//

import Foundation
import UIKit

protocol Navigation: AnyObject {

    func showModal(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    )
    
    func showModal(
        _ viewController: UIViewController,
        animated: Bool
    )

    func hideAllModals(
        animated: Bool,
        completion: (() -> Void)?
    )
    
    func hideAllModals(
        animated: Bool
    )

}

extension UIViewController: Navigation {
    
    func showModal(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        showModal(
            viewController,
            animated: animated,
            completion: nil
        )
    }
    
    func showModal(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        present(
            viewController,
            animated: animated,
            completion: completion
        )
    }

    func hideAllModals(
        animated: Bool,
        completion: (() -> Void)?
    ) {
        if presentedViewController != nil {
            dismiss(
                animated: animated,
                completion: completion
            )
        }
    }
    
    func hideAllModals(
        animated: Bool
    ) {
        hideAllModals(
            animated: animated,
            completion: nil
        )
    }

}

protocol StackBasedNavigation: Navigation {
    
    var childs: [Any] { get }

    func push(_ viewController: UIViewController, animated: Bool)

    @discardableResult
    func pop(animated: Bool) -> UIViewController?
}

extension UINavigationController: StackBasedNavigation {
    
    var childs: [Any] {
        viewControllers
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool) -> UIViewController? {
        return popViewController(animated: animated)
    }
}
