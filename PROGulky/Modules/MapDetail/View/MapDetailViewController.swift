//
//  MapDetailViewController.swift
//  PROGulky
//
//  Created by Ivan Tazenkov on 29/11/2022.
//

import UIKit

// MARK: - MapDetailViewController

final class MapDetailViewController: UIViewController {
    var output: MapDetailViewOutput!
    private var mapView: UIView!

    private var detailViewController: DetailExcursionViewController!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .prog.Dynamic.background
        setupNavigationBar()
        output.viewDidLoad()
    }

    private func setupNavigationBar() {
        navigationController?.tabBarController?.tabBar.isHidden = true
        let backButtonItem = UIBarButtonItem()
        backButtonItem.tintColor = .black
        backButtonItem.title = nil
        backButtonItem.style = .plain
        backButtonItem.target = self
        backButtonItem.action = #selector(backButtonTapped)
        backButtonItem.image = UIImage(systemName: "chevron.left")
        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc
    private func backButtonTapped() {
        output.backButtonTapped()
    }
}

extension MapDetailViewController: MapDetailViewInput {
}

// MARK: MapDetailTransitionHandlerProtocol

extension MapDetailViewController: MapDetailTransitionHandlerProtocol {
    func embedDetailModule(_ viewController: UIViewController) {
        guard let detailViewController = viewController as? DetailExcursionViewController else { return }
        detailViewController.viewDidLoad()

        isModalInPresentation = true
        detailViewController.isModalInPresentation = true

        if let sheet = detailViewController.sheetPresentationController {
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: .medium) { _ in
                170
            }

            sheet.detents = [smallDetent, .large()]
            sheet.preferredCornerRadius = 13
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = smallDetent.identifier
            sheet.prefersGrabberVisible = true
            sheet.delegate = self
        }
        present(detailViewController, animated: true)
    }

    func embedMapModule(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        mapView = viewController.view
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.top.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.bottom.equalToSuperview()
        }
    }
}

// MARK: UISheetPresentationControllerDelegate

extension MapDetailViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        guard let detailViewController = sheetPresentationController.presentedViewController as? DetailExcursionViewController else {
            return
        }
//        detailViewController.resize()
        let size: DetailExcursionViewController.Size
        guard let id = sheetPresentationController.selectedDetentIdentifier else { return }
//        if sheetPresentationController.selectedDetentIdentifier == .medium {
//
//        }
        switch id {
        case .large: size = .large
        case .medium: size = .small
        default:
            return
        }

        sheetPresentationController.animateChanges {
            detailViewController.resize(size)
        }
        
    }
}
