//
//  AddCustomPlace.swift
//  PROGulky
//
//  Created by Тазенков Иван on 24.05.2024.
//

import SwiftUI
import PhotosUI

struct AddCustomPlace: View {
	@ObservedObject var viewModel: AddCustomPlaceViewModel
	@Environment(\.presentationMode) var presentationMode
	@State var selectedItem: PhotosPickerItem?
	@State var image: UIImage?
	@State var title: String = ""
	@State var description: String = ""
	@State var address: String = ""
	@State var longitute: String = ""
	@State var latitute: String = ""
	@State var isWrong = false
	@Binding var isShow: Bool

	var body: some View {
		List {
			PhotosPicker(selection: $selectedItem) {
				if let photo = image {
					Image(uiImage: photo)
						.resizable()
						.scaledToFit()
						.frame(maxWidth: .infinity, alignment: .center)
				} else {
					Image(systemName: "photo")
						.resizable()
						.scaledToFit()
					//						.frame(width: 200, height: 200, alignment: .center)
						.frame(maxWidth: .infinity, alignment: .center)
				}
			}
			.listRowBackground(EmptyView())
			.frame(alignment: .center)
			Section {
				TextField(text: $title, prompt: Text("Интересная Москва")) {
					Text("Название")
				}
			}
			Section("Описание") {
				TextEditor(text: $description)
					.lineLimit(20, reservesSpace: true)
			}
			Section("Адрес") {
				TextField(text: $address, prompt: Text("Тверская, 5")) {
					Text("Адрес")
				}
			}
			Section("Координаты") {
				TextField(text: $latitute, prompt: Text("Широта")) {
					Text("Широта")
				}
				TextField(text: $longitute, prompt: Text("Долгота")) {
					Text("Долгота")
				}
			}

			if viewModel.isLoading {
				ProgressView("Загрузка")
					.frame(maxWidth: .infinity, alignment: .center)
					.listRowBackground(EmptyView())
			}
			Button(action: {
				guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
					  !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
					  !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
					  !latitute.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
					  !longitute.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
					  let doubleLatitude = Double(latitute),
					  let doubleLongitude = Double(longitute),
					  let image = image
				else {
					isWrong = true
					return
				}
				viewModel.sendPlace(
					PlaceForPost(
						title: title,
						description: description,
						address: address,
						city: "Москва",
						latitude: doubleLatitude,
						longitude: doubleLongitude,
						image: ""
					),
					image: image
				)

			}, label: {
				Text("Добавить")
			})
			.foregroundColor(.white)
			.listRowBackground(Color(uiColor: .prog.Dynamic.primary))
			.clipped()
			.frame(height: 28)
			.frame(maxWidth: .infinity, maxHeight: 28, alignment: .center)
		}
		.alert(LocalizedStringKey(stringLiteral: "Заполните все поля"), isPresented: $isWrong, actions: {
			Button(action: {
				isWrong = false
			}, label: {
				Text("ОК")
			})
		})
		.alert(LocalizedStringKey(stringLiteral: "Что-то пошло не так, попробуйте позже"), isPresented: $viewModel.serverError, actions: {
			Button(action: {
				viewModel.serverError = false
			}, label: {
				Text("ОК")
			})
		})	
		.alert(LocalizedStringKey(stringLiteral: "Место успешно добавлено"), isPresented: $viewModel.done, actions: {
			Button(action: {
				isShow = false
				presentationMode.wrappedValue.dismiss()
			}, label: {
				Text("ОК")
			})
		})
		.onChange(of: selectedItem) { _, newItem in
			Task {
				guard let imageData = try? await newItem?.loadTransferable(type: Data.self) else { return }
				image = UIImage(data: imageData)
			}
		}
		
	}
}

#Preview {
	//	let viewModel = AddCustomPlaceViewModel()
	//	return AddCustomPlace(viewModel: viewModel)
	NavigationStack {
		let viewModel = AddPlaceViewModel(moduleOutput: nil)
		return AddPlaceView(viewModel: viewModel)
	}
}
