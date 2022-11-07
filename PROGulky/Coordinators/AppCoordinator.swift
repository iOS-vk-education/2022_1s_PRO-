//
//  AppCoordinator.swift
//  PROGulky
//
//  Created by Иван Тазенков on 02.11.2022.
//

import Foundation
import UIKit

// MARK: - AppCoordinator

final class AppCoordinator: NSObject, CoordinatorProtocol {
    // MARK: Public Properties

    var childCoordinators = [CoordinatorProtocol]()
    let tabBarController: UITabBarController

    // MARK: Lifecycle

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    // MARK: Public

    func start(animated: Bool) {
        tabBarController.delegate = self
        tabBarController.tabBar.backgroundColor = .white
        TabBarPage.allCases.forEach {
            getTabController($0)
        }
    }

    // MARK: Private

    private func getTabController(_ page: TabBarPage) {
        switch page {
        case .excursionList:
            let excursionListCoordinator = ExcursionListCoordinator(rootTabBarController: tabBarController)
            excursionListCoordinator.start(animated: false)
            childCoordinators.append(excursionListCoordinator)
        case .favourite:
            let favouriteCoordinator = FavouriteCoordinator(rootTabBarController: tabBarController)
            favouriteCoordinator.start(animated: false)
            childCoordinators.append(favouriteCoordinator)
        case .profile:
            let profileCoordinator = ProfileCoordinator(rootTabBarController: tabBarController)
            profileCoordinator.start(animated: false)
            childCoordinators.append(profileCoordinator)
        }
    }
}

// MARK: UITabBarControllerDelegate

extension AppCoordinator: UITabBarControllerDelegate {
}