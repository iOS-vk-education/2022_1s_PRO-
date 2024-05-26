//
//  AddPlaceView.swift
//  PROGulky
//
//  Created by Иван Тазенков on 26.12.2022.
//

import SwiftUI
import Combine
// MARK: - AddPlaceView

struct AddPlaceView: View {
	@ObservedObject var viewModel: AddPlaceViewModel
	@Environment(\.colorScheme) private var colorScheme
	@State var isPresenting = true
	@State private var text = ""
	@State private var showCancelButton: Bool = false
	@State private var isShowingAddCustomPlace = true

	private var textColor: Color {
		switch colorScheme {
		case .dark:
			return .white
		case .light:
			return .black
		}
	}
	var body: some View {
		NavigationStack {
			searchBar
				.padding(.horizontal)
				.navigationBarHidden(false)
			List {
				ForEach(viewModel.places.filter { place in
					text == "" || place.title.lowercased().contains(text
						.lowercased()
						.trimmingCharacters(in: .whitespacesAndNewlines))

				}) { place in
					HStack {
						Button(action: {
							viewModel.selectPlace(place: place)
						}, label: {
							HStack {
								Text(place.title)
									.foregroundColor(textColor)
								Spacer()

								if viewModel.selectedPlaces.contains(where: { pl in
									pl.id == place.id
								}) {
									Image(systemName: "checkmark")
										.foregroundColor(.green)
								}
							}
						})
					}
				}

			}
			.toolbar {
				NavigationLink() {
					AddCustomPlace(viewModel: AddCustomPlaceViewModel(), isShow: $isShowingAddCustomPlace)
				} label: {
					Image(systemName: "plus")
				}

			}
		}
		.onChange(of: isShowingAddCustomPlace) {
			viewModel.reload()
		}
		.onDisappear {
			viewModel.viewWillDisappear()
		}
	}

	@ViewBuilder
	var searchBar: some View {
		HStack {
			HStack {
				Image(systemName: "magnifyingglass")
				TextField("Поиск", text: $text, onEditingChanged: { isEditing in
					self.showCancelButton = isEditing
				}, onCommit: {
				}).foregroundColor(.primary)

				Button {
					self.text = ""
				} label: {
					Image(systemName: "xmark.circle.fill").opacity(text == "" ? 0 : 1)
				}
			}
			.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
			.foregroundColor(.secondary)
			.background(Color(.secondarySystemBackground))
			.cornerRadius(10.0)

			if showCancelButton {
				Button("Cancel") {
					UIApplication.shared.endEditing(true)
					self.text = ""
					self.showCancelButton = false
				}
				.foregroundColor(Color(.systemBlue))
			}
		}
	}
}


#Preview {
	NavigationStack {
		let viewModel = AddPlaceViewModel(moduleOutput: nil)
		return AddPlaceView(viewModel: viewModel)
	}
}
