//
//  ExcursionListCoordinator.swift
//  PROGulky
//
//  Created by Иван Тазенков on 02.11.2022.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - ExcursionListCoordinator

final class ExcursionListCoordinator: CoordinatorProtocol {
    // MARK: Private Properties

    private weak var rootTabBarController: UITabBarController?
    private var rootNavigationController: UINavigationController
    private let tabBarItemFactory: TabBarItemFactoryProtocol

    var navigationController: UINavigationController {
        rootNavigationController
    }

    // MARK: Lifecycle

    init(rootTabBarController: UITabBarController) {
        self.rootTabBarController = rootTabBarController
        rootNavigationController = UINavigationController()
        tabBarItemFactory = TabBarItemFactory()
    }

    // MARK: Public Methods

    func start(animated: Bool) {
        let builder = ExcursionsListModuleBuilder()
        let excursionListViewController = builder.build(moduleOutput: self)
        rootNavigationController.setViewControllers([excursionListViewController], animated: animated)

        rootNavigationController.tabBarItem = tabBarItemFactory.getTabBarItem(from: TabBarPage.excursionList)

        var controllers = rootTabBarController?.viewControllers
        if controllers == nil {
            controllers = [rootNavigationController]
        } else {
            controllers?.append(rootNavigationController)
        }
        rootTabBarController?.setViewControllers(controllers, animated: animated)
    }
}

// MARK: ExcursionsListModuleOutput

extension ExcursionListCoordinator: ExcursionsListModuleOutput {
    func excursionsListModuleWantsToOpenDetailModule(excursionId: Int) {
        let detailExcursionViewModel = DetailExcursionViewModel(excursionId: excursionId)
        let detailExcursionView = DetailExcursionView(viewModel: detailExcursionViewModel)
        let hostingViewController = UIHostingController(rootView: detailExcursionView)
        rootNavigationController.navigationBar.standardAppearance.configureWithTransparentBackground()
        rootNavigationController.navigationBar.standardAppearance.backgroundColor = .clear
        hostingViewController.navigationItem.setHidesBackButton(true, animated: false)
        rootNavigationController.pushViewController(hostingViewController, animated: true)
    }
}

// MARK: DetailExcursionModuleOutput

extension ExcursionListCoordinator {
    func excursionsListModuleWantsToOpenAddExcursion() {
        let builder = AddExcursionModuleBuilder()
        let addView = builder.build(moduleOutput: self)
        rootNavigationController.pushViewController(addView, animated: true)
    }
}

// MARK: AddExcursionModuleOutput

extension ExcursionListCoordinator: AddExcursionModuleOutput {
    func addExcursionModuleWantsToClose() {
        rootNavigationController.popViewController(animated: true)
    }

    func addExcursionModuleWantsToOpenAddPlaceModule() {
        let addPlaceViewModel = AddPlaceViewModel(moduleOutput: self)
        let addPlaceView = AddPlaceView(viewModel: addPlaceViewModel)
        let hosting = UIHostingController(rootView: addPlaceView)
//		hosting.navigationController?.navigationBar.
        rootNavigationController.present(hosting, animated: true)
    }
}

// MARK: AppPlaceViewModuleOutput

extension ExcursionListCoordinator: AppPlaceViewModuleOutput {
    func addPlaceViewModuleWantsToClose() {
        guard let addExcursionViewController: AddExcursionViewInput = rootNavigationController.topViewController
            as? AddExcursionViewController else { return }
        addExcursionViewController.reload(false)
    }
}
