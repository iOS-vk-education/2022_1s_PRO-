//
//  UserAuthService.swift
//  PROGulky
//
//  Created by Сергей Киселев on 22.12.2022.
//

import Foundation

// MARK: - UserDefaultsLoginServiceProtocol

protocol UserDefaultsLoginServiceProtocol {
    func saveUserData(user: User)
    func saveUserAuthData(authData: AuthData)
    func removeUserAuthData()
    func getUserData() -> UserData
}

// MARK: - UserDefaultsManager

final class UserDefaultsManager: UserDefaultsLoginServiceProtocol {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard

    func saveUserAuthData(authData: AuthData) {
        defaults.set(authData.accessToken, forKey: UserKeys.accessToken.rawValue)
        defaults.set(authData.refreshToken, forKey: UserKeys.refreshToken.rawValue)
        defaults.set(true, forKey: UserKeys.isLogin.rawValue)
    }

    func setImageData(imageName: String) {
        defaults.set(imageName, forKey: UserKeys.image.rawValue)
        defaults.synchronize()
    }

    func saveUserData(user: User) {
//        defaults.set(user.token, forKey: UserKeys.token.rawValue)
        defaults.set(user.id, forKey: UserKeys.id.rawValue)
        defaults.set(user.email, forKey: UserKeys.email.rawValue)
        defaults.set(user.name, forKey: UserKeys.name.rawValue)
        defaults.set(user.image, forKey: UserKeys.image.rawValue)
        defaults.set(user.role.description, forKey: UserKeys.role.rawValue)
//        defaults.set(true, forKey: UserKeys.isLogin.rawValue)
        defaults.synchronize()
    }

    func removeUserAuthData() {
        UserKeys.AllCases().forEach { key in
            defaults.removeObject(forKey: key.rawValue)
        }
        print(1)
        defaults.set(false, forKey: UserKeys.isLogin.rawValue)
        print(2)
        defaults.synchronize()
    }

    var isLogged: Bool {
        guard
            defaults.string(forKey: UserKeys.isLogin.rawValue) != nil,
            let isAuth = defaults.string(forKey: UserKeys.isLogin.rawValue)
        else {
            return false
        }
        return isAuth == "1"
    }

	var isGuide: Bool {
		guard
			isLogged,
			defaults.string(forKey: UserKeys.role.rawValue) != nil,
			let role = defaults.string(forKey: UserKeys.role.rawValue)
		else {
			return false
		}
		return role == "Экскурсовод" || role == "Администратор"
	}

//    // метод мне не нравится
//    func isLogged() -> Bool {
//        guard defaults.string(forKey: UserKeys.isLogin.rawValue) != nil else {
//            return false
//        }
//        if let isAuth = defaults.string(forKey: UserKeys.isLogin.rawValue) {
//            if isAuth == "1" { // не знаю как избавиться от этого сравнения строк.
//                return true
//            }
//        }
//        return false
//    }

    func getUserId() -> Int? {
        guard let id = defaults.string(forKey: UserKeys.id.rawValue) else { return nil }
        return Int(id)
    }

    func getUserData() -> UserData {
        let token = defaults.string(forKey: UserKeys.token.rawValue)
        let email = defaults.string(forKey: UserKeys.email.rawValue)
        let name = defaults.string(forKey: UserKeys.name.rawValue)
        let displayRole = defaults.string(forKey: UserKeys.role.rawValue)
		let image = defaults.string(forKey: UserKeys.image.rawValue)

        let userData = UserData(
            name: name ?? "",
            email: email ?? "",
            token: token ?? "",
            role: displayRole ?? "",
			image: image
        )
        return userData
    }

    func getToken() -> AuthData {
        let accessToken = defaults.string(forKey: UserKeys.accessToken.rawValue)
        let refreshToken = defaults.string(forKey: UserKeys.refreshToken.rawValue)
        let refreshExpiresAt = defaults.string(forKey: UserKeys.refreshExpiresAt.rawValue)

        let token = AuthData(
            accessToken: accessToken ?? "",
            refreshToken: refreshToken ?? "",
            refreshExpiresAt: refreshExpiresAt ?? ""
        )
        return token
    }
}
