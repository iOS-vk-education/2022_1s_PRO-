//
//  PreviewPPlaceViewModel.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 18.11.2022.
//

import Foundation

// MARK: - PreviewPlaceViewModel

// Данные в ячейки таблицы с местами
struct PreviewPlaceViewModel: Identifiable {
	let id: Int
    var sort: Int
    var title: String
    var subtitle: String
}
