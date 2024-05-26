//
//  DetailExcursionViewModel.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 23.11.2022.
//

import Foundation

struct DetailExcursion {
    var id: Int
    var image: String
    var description: String
    var infoViewModel: DetailExcursionInfoModel
    var isLiked: Bool
    var places: [PreviewPlaceViewModel]

    static var empty: DetailExcursion {
        .init(
            id: 0,
            image: "",
            description: "",
            infoViewModel: DetailExcursionInfoModel.empty,
            isLiked: false,
            places: []
        )
    }
}
