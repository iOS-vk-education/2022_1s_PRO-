//
//  DetailExcursionDisplayDataFactory.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 17.11.2022.
//

import Foundation

// MARK: - DetailExcursionDisplayDataFactoryProtocol

protocol DetailExcursionDisplayDataFactoryProtocol {
    func setupViewModel(excursion: Excursion) -> DetailExcursionViewModel

    func getPlaceViewModel(for index: Place) -> PlaceViewModel
}

// MARK: - DetailExcursionDisplayDataFactory

class DetailExcursionDisplayDataFactory: DetailExcursionDisplayDataFactoryProtocol {
    func getPlaceViewModel(for place: Place) -> PlaceViewModel {
        PlaceViewModel(sort: String(place.sort), title: place.title, subtitle: place.address)
    }

    func setupViewModel(excursion: Excursion) -> DetailExcursionViewModel {
        DetailExcursionViewModel(
            image: excursion.image ?? "placeholderImage",
            description: excursion.description,
            infoViewModel: DetailExcursionInfoViewModel(
                title: excursion.title,
                rating: "\(excursion.rating)",
                numberOfPlaces: excursion.numberOfPoints.wordEnding(for: "мест"),
                duration: "\(excursion.duration) мин",
                distance: "\(excursion.distance) км"
            )
        )
    }
}
