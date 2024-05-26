//
//  Place.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 19.11.2022.
//

import Foundation

// MARK: - Place

struct Place: Codable, Identifiable, Hashable {
    var id: Int?
    var sort: Int?
    let title: String
    let description: String
    let image: String?
    let address: String
    let city: String
    let latitude: Double
    let longitude: Double
}

// MARK: - PreviewPlace

struct PreviewPlace: Codable {
    let id: Int
    let sort: Int?
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
}

// MARK: - PlaceWithImageData

struct PlaceWithImageData: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let image: String
    let address: String
    let city: String
    let latitude: Double
    let longitude: Double
}
