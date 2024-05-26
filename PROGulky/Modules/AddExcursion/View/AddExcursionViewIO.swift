//
//  AddExcursionViewIO.swift
//  PROGulky
//
//  Created by SemyonPyatkov on 31/10/2022.
//

import Foundation
import UIKit

// MARK: - AddExcursionViewOutput

protocol AddExcursionViewOutput: AnyObject {
    var selectedPlacesCount: Int { get }
    var routeDistance: Double { get }
    var routeDuration: Int { get }
    func didTapAddPlaceButton()
    func place(for indexPath: IndexPath) -> Place

    func removePlace(at indexPath: IndexPath)
    func swapPlaces(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func didTapSaveButton(name: String, description: String, image: UIImage)
	func reloadData(_ hasInnerChanges: Bool)
}

// MARK: - AddExcursionViewInput

protocol AddExcursionViewInput: AnyObject {
    func reload(_: Bool)
    func reloadHeaderView()
    func showAuthView()
    func showErrorView()
	func reloadPlaces()
}
