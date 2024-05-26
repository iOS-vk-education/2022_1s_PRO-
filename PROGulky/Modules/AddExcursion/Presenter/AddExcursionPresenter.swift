//
//  AddExcursionPresenter.swift
//  PROGulky
//
//  Created by SemyonPyatkov on 31/10/2022.
//

import Foundation
import YandexMapsMobile

// MARK: - AddExcursionPresenter

final class AddExcursionPresenter {
    // MARK: - Public Properties

    weak var view: AddExcursionViewInput!

    // MARK: - Private Properties

    private let interactor: AddExcursionInteractorInput
    private let router: AddExcursionRouterInput
    private weak var moduleOutput: AddExcursionModuleOutput?
    private let selectedPlacesManager = SelectedPlacesManager.sharedInstance
    private var selectedPlaces: [Place] { selectedPlacesManager.selectedPlaces }
    private var distance: Double = 0
    private var duration = 0
    private var massTransitSession: YMKMasstransitSession?

    // MARK: - Lifecycle

    init(interactor: AddExcursionInteractorInput, router: AddExcursionRouterInput, moduleOutput: AddExcursionModuleOutput) {
        self.interactor = interactor
        self.router = router
        self.moduleOutput = moduleOutput
    }

	private func calculateDistanceAndDuration(_ hasChanges: Bool) {
        let lastWayPointNumber = selectedPlaces.count - 1

        let requestPoints = selectedPlaces.enumerated().map { element in
            let place = element.element
            let count = element.offset
            let point = YMKRequestPoint(
                point: YMKPoint(latitude: place.latitude,
                                longitude: place.longitude),
                type: count == 0 || count == lastWayPointNumber ? .waypoint : .viapoint,
                pointContext: nil
            )
            return point
        }

        let pedestrianRouter = YMKTransport.sharedInstance().createPedestrianRouter()
        massTransitSession = pedestrianRouter.requestRoutes(
            with: requestPoints,
            timeOptions: YMKTimeOptions(departureTime: Date(), arrivalTime: nil),
            routeHandler: { [weak self] (routeResponse: [YMKMasstransitRoute]?, error: Error?) in
				if error != nil {
                    self?.duration = 0
                    self?.distance = 0
                    self?.reloadHeaderView(hasChanges)
                    return
                }
                guard let route = routeResponse?.first else {
                    return
                }

                self?.distance = route.metadata.weight.walkingDistance.value / 1000
                self?.duration = Int(route.metadata.weight.time.value / 60)
                self?.reloadHeaderView(hasChanges)
            }
        )
    }

	private func reloadHeaderView(_ hasChanges: Bool) {
		if hasChanges {
			view.reloadHeaderView()
		} else {
			view.reloadPlaces()
		}
    }
}

extension AddExcursionPresenter: AddExcursionModuleInput {
}

// MARK: AddExcursionViewOutput

extension AddExcursionPresenter: AddExcursionViewOutput {
    var routeDistance: Double {
        distance
    }

    var routeDuration: Int {
        duration
    }

    func didTapSaveButton(name: String, description: String, image: UIImage) {
        let places = selectedPlaces.map { "\($0.id ?? 0)" }
        let placeIds = places.joined(separator: ",")
        let excursion = ExcursionForPost(title: name,
                                         description: description,
                                         image: "",
                                         duration: duration,
                                         distance: distance,
                                         placesIds: placeIds)
        interactor.sendExcursion(excursion: excursion, image: image)
    }

    var selectedPlacesCount: Int {
        selectedPlacesManager.selectedPlaces.count
    }

    func didTapAddPlaceButton() {
        moduleOutput?.addExcursionModuleWantsToOpenAddPlaceModule()
    }

    func place(for indexPath: IndexPath) -> Place {
        selectedPlacesManager.selectedPlaces[indexPath.row]
    }

    func removePlace(at indexPath: IndexPath) {
        selectedPlacesManager.remove(at: indexPath.row)
		reloadData(false)
    }

    func swapPlaces(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        selectedPlacesManager.swap(from: sourceIndexPath.row,
                                   to: destinationIndexPath.row)
    }

	func reloadData(_ hasInnerChanges: Bool) {
        calculateDistanceAndDuration(hasInnerChanges)
    }
}

// MARK: AddExcursionInteractorOutput

extension AddExcursionPresenter: AddExcursionInteractorOutput {
    func successeded() {
        selectedPlacesManager.removeAll()
        moduleOutput?.addExcursionModuleWantsToClose()
    }

    // Ошибка авторизации
    func gotAuthError() {
        view.showAuthView()
    }

    // Ошибка сервера
    func gotAnotherError() {
        view.showErrorView()
    }
}
