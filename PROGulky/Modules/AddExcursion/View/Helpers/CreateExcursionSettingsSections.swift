//
//  CreateExcursionSettingsSections.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 09.12.2022.
//

import Foundation

enum CreateExcursionSettingsSections: Int, CaseIterable {
    case image
    case titleSection
    case descriptionSection
    case selectedPlaces
    case addButton

    var description: String {
        switch self {
        case .selectedPlaces:
            return "Точки маршрута"
        case .addButton:
            return "Описание"
        case .image:
            return "image"
        case .titleSection:
            return "title"
        case .descriptionSection:
            return "desc"
        }
    }
}
