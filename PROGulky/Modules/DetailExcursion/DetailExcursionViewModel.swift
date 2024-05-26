//
//  DetailExcursionViewModel.swift
//  PROGulky
//
//  Created by Ivan Tazenkov on 23.04.2023.
//

import Foundation
import Combine
import YandexMapsMobile
import CoreLocation

// MARK: - DetailExcursionViewModel

final class DetailExcursionViewModel: NSObject, ObservableObject {
    @Published var excursion = DetailExcursion.empty
    @Published var places = [PlaceCoordinates.empty]
    var excursionData: Excursion?
    var isFavourite: Bool = false // Есть ли экскурсия с переданным id в избранном
//    private var excursionCancelable: AnyCancellable?
    private var massTransitSession: YMKMasstransitSession?
    private var requestPoints = [YMKRequestPoint]()
    @Published var polyline = YMKPolyline(points: [])
    @Published var loading: Bool = true
    @Published var points = [YMKPoint]()
    @Published var error: ApiCustomError?

    var guardedExcursion: Excursion {
        guard let excursionData else { return .empty }
        return excursionData
    }

    init(excursionId: Int,
		 initialExcursion value: Excursion? = nil
	) {
		super.init()
		excursion.id = excursionId
		if let value {
			self.excursionData = value
			self.isFavourite = ExcursionsRepository.shared
				.getIssetFavouriveExcursion(with: value.id)
			self.excursion = DetailExcursionDisplayDataFactory()
				.setupViewModel(excursion: value, isFavourite: value.isFavorite)
			self.places = DetailExcursionDisplayDataFactory().getPlacesCoordinates(value.places)
			self.getRoute()
			self.loading = false
		} else {
			refresh()
		}
    }

    public func didiLikeButtonTapped() {
        excursion.isLiked.toggle()
        guard let excursion = excursionData else { return }

        if isFavourite == false {
            isFavourite = true
            ExcursionsRepository.shared.addFavouriveExcursion(with: excursion)
        } else {
            isFavourite = false
            ExcursionsRepository.shared.removeFavouriveExcursion(with: excursion.id)
        }
    }

    func refresh() {
        guard excursionData == nil else { return }
        loading = true
		ApiManager.shared.getExcursion(excursionId: excursion.id) { [weak self] result in
			guard let self else { return }
			switch result {
			case .success(let value):
				self.excursionData = value
				self.isFavourite = ExcursionsRepository.shared
					.getIssetFavouriveExcursion(with: self.excursion.id)
				self.excursion = DetailExcursionDisplayDataFactory()
					.setupViewModel(excursion: value, isFavourite: self.isFavourite)
				self.places = DetailExcursionDisplayDataFactory().getPlacesCoordinates(value.places)
				self.getRoute()
				self.loading = false
			case .failure(let error):
				self.error = error
			}
		}
    }


	func openUrl() {

//		locationManager.requestWhenInUseAuthorization()

		guard var url = URL(string: "https://yandex.ru/maps"),
			  !places.isEmpty
		else { return }
		var coordinatesString = places.reduce(into: "") { partialResult, place in
			partialResult += "\(place.toString)~"
		}
		coordinatesString.removeLast()
		if let location = LocationManager.shared.location {
			coordinatesString = "\(location.coordinatesToString)~\(coordinatesString)"
		}
		url.append(
			queryItems: [
				URLQueryItem(
					name: "rtext",
					value: coordinatesString
				),
				URLQueryItem(
					name: "rtt",
					value: "pd"
				)
			]
		)
//		if UIApplication.shared.canOpenURL(url) {
		UIApplication.shared.open(url) { success in
			if !success {
				self.error = .notMaps
			}
		}
//		} else {
//			self.error = .notMaps
//		}
	}

    private func getRoute() {
        let lastWayPointNumber = places.count - 1

        requestPoints = places.enumerated().map { element in
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
            }
        }

        let pedestrianRouter = YMKTransport.sharedInstance().createPedestrianRouter()
        massTransitSession = pedestrianRouter.requestRoutes(
            with: requestPoints,
            timeOptions: YMKTimeOptions(departureTime: Date(), arrivalTime: nil),
            routeHandler: responseHandler
        )
    }

    private func onRoutesReceived(_ routes: [YMKMasstransitRoute]) {
        guard let route = routes.first else { return }
        polyline = route.geometry
        points = requestPoints.map(\.point)
    }
}


//extension DetailExcursionViewModel: CLLocationManagerDelegate {
//	func locationManager(
//		_ manager: CLLocationManager,
//		didUpdateLocations locations: [CLLocation]
//	) {
//		if let location = locations.first {
//			let latitude = location.coordinate.latitude
//			let longitude = location.coordinate.longitude
//			print(latitude, longitude)
//		}
//	}
//	func locationManager(
//		_ manager: CLLocationManager,
//		didFailWithError error: Error
//	) {
//		self.error = .notMaps
//	}
//}
