//
//  MapPresenter.swift
//  PROGulky
//
//  Created by Ivan Tazenkov on 21/11/2022.
//

// MARK: - MapPresenter

import Foundation
import YandexMapsMobile

// MARK: - MapPresenter

final class MapPresenter {
    // MARK: - Public Properties

    weak var view: MapViewInput!

    // MARK: - Private Properties

    private let excursion: Excursion
    private var massTransitSession: YMKMasstransitSession?
    private var requestPoints = [YMKRequestPoint]()
    private weak var moduleOutput: MapModuleOutput?

    // MARK: - Lifecycle

    init(excursion: Excursion) {
        self.excursion = excursion
    }

    private func onRoutesReceived(_ routes: [YMKMasstransitRoute]) {
        guard let route = routes.first else { return }
        let points = requestPoints.map(\.point)
        view.routeRecieved(route: route, points: points)
    }

    private func onRoutesError(_ error: Error) {
        guard let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey]
            as? YRTError else { return }
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        view.showAlert(with: errorMessage)
    }
}

extension MapPresenter: MapModuleInput {
}

// MARK: MapViewOutput

extension MapPresenter: MapViewOutput {
    func didLoadView() {
        let lastWayPointNumber = excursion.places.count - 1

		requestPoints = excursion.places
			.sorted(by: { lhs, rhs in
				guard let first = lhs.sort,
					  let second = rhs.sort
				else {
					return lhs.id < rhs.id
				}
				return first < second
			})
			.enumerated()
			.map { element in
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

        let responseHandler = { (routesResponse: [YMKMasstransitRoute]?, error: Error?) in
            if let routes = routesResponse {
                self.onRoutesReceived(routes)
            } else {
                self.onRoutesError(error!)
            }
        }

        let pedestrianRouter = YMKTransport.sharedInstance().createPedestrianRouter()
        massTransitSession = pedestrianRouter.requestRoutes(
            with: requestPoints,
            timeOptions: YMKTimeOptions(departureTime: Date(), arrivalTime: nil),
            routeHandler: responseHandler
        )
    }
}
