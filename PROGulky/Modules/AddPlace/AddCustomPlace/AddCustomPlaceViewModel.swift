//
//  AddCustomPlaceViewModel.swift
//  PROGulky
//
//  Created by Тазенков Иван on 24.05.2024.
//

import Foundation
import UIKit

struct PlaceForPost: Encodable {
	let title: String
	let description: String
	let address: String
	let city: String
	let latitude: Double
	let longitude: Double
	var image: String
}
struct PlaceAfterPost: Decodable {
	let id: Int
	let title: String
	let latitude: Double
	let longitude: Double
}
final class AddCustomPlaceViewModel: ObservableObject {
	@Published var serverError = false
	@Published var done = false
	@Published var isLoading = false
	func sendPlace(_ place: PlaceForPost, image: UIImage) {
		isLoading = true
		ApiManager.shared.sendImage(image: image, type: .place) { [weak self] result in
			switch result {
			case let .success(success):
				var newPlace = place
				newPlace.image = success.fileName
				self?.uploadPlace(newPlace)
			case .failure(_):
				self?.serverError = true
//				self?.output?.gotAnotherError()
			}
		}
	}

	private func uploadPlace(_ place: PlaceForPost) {
		ApiManager.shared.uploadPlace(place: place) { [weak self] result in
			switch result {
			case let .success(place):
				print(place)
				self?.done = true
			case let .failure(error):
				self?.serverError = true
				print(error)
			}
			self?.isLoading = false
		}
	}
	
}


