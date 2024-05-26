//
//  AddExcursionInteractor.swift
//  PROGulky
//
//  Created by SemyonPyatkov on 31/10/2022.
//

import UIKit

// MARK: - AddExcursionInteractor

final class AddExcursionInteractor {
    weak var output: AddExcursionInteractorOutput?

    private func uploadExcursion(excursion: ExcursionForPost) {
        ApiManager.shared.sendExcursion(excursion: excursion) { [weak self] result in
            switch result {
            case .success:
                self?.output?.successeded()
            case .failure:
                self?.output?.gotAnotherError()
            }
        }
    }
}

// MARK: AddExcursionInteractorInput

extension AddExcursionInteractor: AddExcursionInteractorInput {
    func sendExcursion(excursion: ExcursionForPost, image: UIImage) {
		ApiManager.shared.sendImage(image: image, type: .excursion) { [weak self] result in
            switch result {
            case let .success(success):
                var newExcursion = excursion
                newExcursion.image = success.fileName
                self?.uploadExcursion(excursion: newExcursion)
            case .failure:
                self?.output?.gotAnotherError()
            }
        }
    }
}
