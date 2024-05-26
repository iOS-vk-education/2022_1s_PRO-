//
//  PlaceCoordinates.swift
//  PROGulky
//
//  Created by Ivan Tazenkov on 23.04.2023.
//

import Foundation
struct PlaceCoordinates {
    let latitude: Double
    let longitude: Double

    static var empty: PlaceCoordinates {
        .init(latitude: 0, longitude: 0)
    }

	var toString: String {
		return "\(latitude),\(longitude)"
	}
}
