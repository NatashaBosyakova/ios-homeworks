//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Наталья Босякова on 27.11.2022.
//

import Foundation

final class FeedCoordinator: AppCoordinator {

    private weak var transitionHandler: StackBasedNavigation?

    var childs: [AppCoordinator] = []

}
