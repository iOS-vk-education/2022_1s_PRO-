//
//  DetailExcursionDisplayDataFactory.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 17.11.2022.
//

import Foundation

// MARK: - DetailExcursionDisplayDataFactoryProtocol

protocol DetailExcursionDisplayDataFactoryProtocol {
    func setupViewModel(excursion: Excursion, isFavourite: Bool) -> DetailExcursion

    func getPlacesCoordinates(_: [PreviewPlace]) -> [PlaceCoordinates]
}

// MARK: - DetailExcursionDisplayDataFactory

class DetailExcursionDisplayDataFactory: DetailExcursionDisplayDataFactoryProtocol {
    func getPlacesCoordinates(_ places: [PreviewPlace]) -> [PlaceCoordinates] {
        places.map {
            PlaceCoordinates(latitude: $0.latitude, longitude: $0.longitude)
        }
    }

    func setupViewModel(excursion: Excursion, isFavourite: Bool) -> DetailExcursion {
        DetailExcursion(
            id: excursion.id,
            image: excursion.image ?? "placeholderImage",
            description: excursion.description,
            infoViewModel: infoViewModel(excursion),
            isLiked: isFavourite,
            places: excursion.places.map(converPlace)
        )
    }

    private func converPlace(_ place: PreviewPlace) -> PreviewPlaceViewModel {
        PreviewPlaceViewModel(sort: place.sort ?? 0, title: place.title, subtitle: place.address)
    }

    private func infoViewModel(_ excursion: Excursion) -> DetailExcursionInfoModel {
        var displayRating: String
        if let rating = excursion.rating {
            displayRating = "\(rating)"
        } else {
            displayRating = "Без рейтинга"
        }

        return DetailExcursionInfoModel(
            title: excursion.title,
            rating: displayRating,
            numberOfPlaces: excursion.numberOfPoints.wordEnding(for: "мест"),
            duration: "\(excursion.duration) мин",
            distance: "\(excursion.distance) км"
        )
    }

    private func convertImage(_ image: String?) -> String {
        guard let image else {
            return "placeholderImage"
        }
        let request = ApiType.getExcursionImage(image: image)
        return request.path + image
    }
}
