//
//  ProfileInteractor.swift
//  PROGulky
//
//  Created by SemyonPyatkov on 31/10/2022.
//

import Foundation

// MARK: - ProfileInteractor

final class ProfileInteractor {
    weak var output: ProfileInteractorOutput?
}

// MARK: ProfileInteractorInput

extension ProfileInteractor: ProfileInteractorInput {
    func setUserImage(with fileName: String) {
        ApiManager.shared.setUserImage(completion: { [weak self] result in
            switch result {
            case let .success(imageName):
                UserDefaultsManager.shared.setImageData(imageName: imageName)
                self?.output?.successSetImage()
            case .failure:
                self?.output?.gotError()
            }
        }, fileName: fileName)
    }

    func logout() {
        UserAuthService.shared.logout()
    }

    func deleteAccount() {
        UserDefaultsManager.shared.removeUserAuthData()
        let token = UserService.shared.userToken
        UserAuthService.shared.deleteAccount(completion: { result in
            switch result {
            case let .success(userData):
                print("[DEBUG] \(userData)")
            case let .failure(error):
                print("[DEBUG] \(error)")
            }
        }, token: token)
    }

    func postUserImage(userAvater: UserImageForPost) {
        ApiManager.shared.sendUserAvatar(userAvater: userAvater) { result in
            switch result {
            case let .success(success):
                self.output?.successLoadImage(with: success.fileName)
			case .failure(_):
                self.output?.gotError()
            }
        }
    }
}
