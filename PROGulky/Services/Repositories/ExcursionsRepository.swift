//
//  ExcursionsRepository.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 20.12.2022.
//

import Foundation

// MARK: - ExcursionsRepositoryConstants

struct ExcursionsRepositoryConstants {
    enum Search {
        static let delay: Float = 1.0
        static let queryParameterKey = "q"
    }
}

// MARK: - ExcursionsRepository

final class ExcursionsRepository {
    static let shared = ExcursionsRepository()

    // Получение (запрос) экскурсий из API.
    // Аргументы:
    // 1 - "text" - название экскусрии (для поиска по ILIKE по title),
    // 2 - "params" - параметры фильтра

    func getExcursionsList(completion: @escaping (Result<PreviewExcursions, Error>) -> Void, with text: String?, filterParameters: [String: String]?) {
        var resParameters: [URLQueryItem] = []

        // Если в text не nil, то формирую массив [URLQueryItem]
        if let text = text {
            let searchQuery = [ExcursionsRepositoryConstants.Search.queryParameterKey: text]
            let params = [searchQuery]

            params.forEach { e in
                guard let key = e.keys.first, let value = e.values.first else { return }
                resParameters.append(URLQueryItem(
                    name: key,
                    value: value
                )
                )
            }
        }

        // Если в params не nil, то формирую массив [URLQueryItem]
        if let filterParameters = filterParameters {
            filterParameters.forEach { e in
                resParameters.append(URLQueryItem(
                    name: e.key,
                    value: e.value
                )
                )
            }
        }

        ApiManager.shared.getExcursions(
            completion: { excursions in
                switch excursions {
                case let .success(excursions):
                    DispatchQueue.main.async {
                        completion(.success(excursions))
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            },
            params: resParameters
        )
    }

    func getFavoritesExcursionsList(completion: @escaping (Result<PreviewExcursions, Error>) -> Void, token: String) {
        ApiManager.shared.getFavoritesExcursions(
            completion: { excursions in
                switch excursions {
                case let .success(excursions):
                    DispatchQueue.main.async {
                        completion(.success(excursions))
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            },
            token: token
        )
    }

    public func addFavouriveExcursion(with excursionInitial: Excursion) {
        guard let userId = UserService.shared.userId else { return }
		ApiManager.shared.getExcursion(excursionId: excursionInitial.id) { [weak self] result in
			switch result {
			case .success(let excursion):
				CoreDataManager.shared.addFavouriteExcursion(
					Int16(excursion.id),
					excursion.title,
					excursion.description,
					excursion.image,
					excursion.rating ?? 0,
					Int16(excursion.duration),
					excursion.distance,
					Int16(excursion.numberOfPoints),
					Int16(excursion.owner.id),
					excursion.owner.name,
					excursion.owner.image,
					Int16(excursion.owner.role.id),
					excursion.owner.role.value,
					excursion.owner.role.description,
					Int16(userId)
				)
			case .failure(let failure):
				<#code#>
			}
		}

    }

    public func removeFavouriveExcursion(with excursionId: Int) {
        CoreDataManager.shared.deleteFavouriteExcursion(with: Int16(excursionId))
    }

    public func getFavouritesExcursions() -> [PreviewExcursion] {
        guard let userId = UserService.shared.userId else { return [] }
        let favoritesExcursions = CoreDataManager.shared.fetchFavouritesExcursions(for: Int16(userId))

        guard !favoritesExcursions.isEmpty else { return [] }

        var result: [PreviewExcursion] = []
        favoritesExcursions.forEach {
            let prepareExcursion = convertCoreDataObjectToPreviewExcursionModel($0)
            result.append(prepareExcursion)
        }
        return result
    }

    // Проверка на наличие в базе записи экскурсии с переданным id
    public func getIssetFavouriveExcursion(with id: Int) -> Bool {
        guard let userId = UserService.shared.userId else { return false }

        let coreDataObject = CoreDataManager.shared.fetchFavouriteExcursion(with: Int16(id), for: Int16(userId))
        return coreDataObject == nil ? false : true
    }

    // привести модель из базы в модель PreviewExcursion
    private func convertCoreDataObjectToPreviewExcursionModel(_ obj: FavouriteExcursion) -> PreviewExcursion {
        let role = Role(
            id: Int(obj.ownerRoleId),
            value: obj.ownerRoleValue ?? "undefine",
            description: obj.ownerRoleDescription ?? "Неизвестно"
        )
        let owner = OwnerInstance(
            id: Int(obj.ownerId),
            name: obj.ownerName ?? "Имя",
            email: "email",
            image: obj.ownerImage,
            role: role
        )
        let excursion = PreviewExcursion(
            id: Int(obj.id),
            title: obj.title ?? "Название",
            image: obj.image,
            rating: obj.rating,
            duration: Int(obj.duration),
            distance: obj.distance,
            numberOfPoints: Int(obj.numberOfPoints),
            owner: owner
        )
        return excursion
    }
}
