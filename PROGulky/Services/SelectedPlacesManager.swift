//
//  SelectedPlacesManager.swift
//  PROGulky
//
//  Created by Иван Тазенков on 26.12.2022.
//

import Foundation

// MARK: - SelectedPlacesManagerProtocol

protocol SelectedPlacesManagerProtocol {
    var selectedPlaces: [Place] { get }
    func addOrRemovePlace(_ place: Place)
    func removeAll()
	func updatePlaces(_ items: Set<Place>)

    func remove(at index: Int)
    func swap(from: Int, to: Int)
}

// MARK: - SelectedPlacesManager

final class SelectedPlacesManager {
    private var userSelectedPlaces = [Place]()
    static var sharedInstance: SelectedPlacesManagerProtocol = SelectedPlacesManager()
}

// MARK: SelectedPlacesManagerProtocol

extension SelectedPlacesManager: SelectedPlacesManagerProtocol {
    var selectedPlaces: [Place] {
        userSelectedPlaces
    }

    func addOrRemovePlace(_ place: Place) {
        if userSelectedPlaces.contains(where: { $0.id == place.id }) {
            userSelectedPlaces = userSelectedPlaces.filter { pl in
                pl.id != place.id
            }
        } else {
            var newPlace = place
            newPlace.sort = userSelectedPlaces.count + 1
            userSelectedPlaces.append(newPlace)
        }
    }

	func updatePlaces(_ items: Set<Place>) {
		var sort = 1
		userSelectedPlaces = items.map({ place in
			var newPlace = place
			newPlace.sort = sort
			sort += 1
			return newPlace
		})
	}

    func removeAll() {
        userSelectedPlaces.removeAll()
    }

    func remove(at index: Int) {
		guard index < userSelectedPlaces.count else { return }
        userSelectedPlaces.remove(at: index)
        userSelectedPlaces = userSelectedPlaces.enumerated().map { el in
            var newElement = el.element
            newElement.sort = el.offset + 1
            return newElement
        }
    }

    func swap(from: Int, to: Int) {
		guard from >= 0,
			  from < userSelectedPlaces.endIndex,
			  to >= 0,
			  to < userSelectedPlaces.endIndex
		else { return }
		let place = userSelectedPlaces.remove(at: from)
        userSelectedPlaces.insert(place, at: to)
        userSelectedPlaces = userSelectedPlaces.enumerated().map { el in
            var newElement = el.element
            newElement.sort = el.offset + 1
            return newElement
        }
    }
}
