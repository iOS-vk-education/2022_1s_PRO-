//
//  DetailPlaceView.swift
//  PROGulky
//
//  Created by Тазенков Иван on 24.05.2024.
//

import SwiftUI
import Combine
import Kingfisher
import SkeletonUI

// MARK: - DetailPlaceView
struct DetailPlaceView: View {
	var placeId: Int
//	@State var placeCancellable: AnyCancellable?
	@State var place: Place?
	@State var loading: Bool = true
	@State var error: ApiCustomError?

	private func reload() {
		guard place == nil else { return }
		loading = true
		print("loading")
		ApiManager.shared.getPlace(placeId: placeId) { result in
			switch result {
			case .success(let success):
				self.place = success
				self.loading = false
			case .failure(let failure):
				self.error = failure
			}
		}
//		placeCancellable = ApiManager.shared
//			.getPlace(id: placeId)
//			.receive(on: RunLoop.main)
//			.sink(receiveCompletion: { response in
//				switch response {
//				case let .failure(error):
//					self.error = error
//				case .finished: break
//				}
//			}, receiveValue: { value in
//				self.place = value
//				self.loading = false
//			})
	}

	var body: some View {
		ZStack {
			List {
				KFImage(URL(string: "\(AddExcursionConstants.Api.imageURL)/\(place?.image ?? "")"))
					.resizable()
					.scaledToFill()
					.skeleton(with: loading)
					.shape(type: .rectangle)
					.listRowBackground(EmptyView())
					.listRowInsets(.none)
				Section("Название") {
					Text(place?.title)
						.skeleton(with: loading)
						.shape(type: .rectangle)
				}
				Section("Адрес") {
					Text(place?.address)
						.skeleton(with: loading)
						.shape(type: .rectangle)
				}
				Section("Описание") {
					Text(place?.description)
						.skeleton(with: loading)
						.shape(type: .rectangle)
//						.multiline(lines: 0)
						.multilineTextAlignment(.leading)
				}


			}
			if let errorMessage = error?.rawValue {
				RepresentedErrorHUDView(errorMessage: errorMessage)
					.frame(width: 200, height: 100, alignment: .center)
			}
		}
		.onAppear{
			reload()
		}
	}
}


#Preview {
	DetailPlaceView(placeId: 1)
}
