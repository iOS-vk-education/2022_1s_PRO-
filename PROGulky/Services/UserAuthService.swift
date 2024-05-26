//
//  UserLoginService.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 24.12.2022.
//

import Foundation

// MARK: - UserAuthService

// Сервис, который может
// 1. проверять наличие логина
// 2. логинить
// 3. регистрировать
// 4. выходить из аккаунта
final class UserAuthService {
    static let shared = UserAuthService()

    var isLogged: Bool {
        UserDefaultsManager.shared.isLogged
    }

    // Регистрация с получением токенов
    func registration(dto: RegistrationDTO, completion: @escaping (Result<AuthData, ApiCustomError>) -> Void) {
        ApiManager.shared.registration(dto) { result in
            switch result {
            case let .success(authData):
                UserDefaultsManager.shared.saveUserAuthData(authData: authData)
                DispatchQueue.main.async {
                    completion(.success(authData))
                }
            case let .failure(failure):
                DispatchQueue.main.async {
                    completion(.failure(failure))
                }
            }
        }
    }

    // Получение токенов
    func login(dto: LoginDTO, completion: @escaping (Result<AuthData, ApiCustomError>) -> Void) {
        ApiManager.shared.login(dto) { result in
            switch result {
            case let .success(authData):
                UserDefaultsManager.shared.saveUserAuthData(authData: authData)
                DispatchQueue.main.async {
                    completion(.success(authData))
                }
            case let .failure(failure):
                DispatchQueue.main.async {
                    completion(.failure(failure))
                }
            }
        }
    }

    func getMeInfo(completion: @escaping (Result<User, ApiCustomError>) -> Void, token: String) {
        ApiManager.shared.getMeInfo(
            completion: { result in
                switch result {
                case let .success(user):
                    UserDefaultsManager.shared.saveUserData(user: user)
                    DispatchQueue.main.async {
                        completion(.success(user))
                    }
                case let .failure(failure):
                    DispatchQueue.main.async {
                        completion(.failure(failure))
                    }
                }
            },
            token: token
        )
    }

    // Удаление аккаунта
    func deleteAccount(completion: @escaping (Result<User, ApiCustomError>) -> Void, token: String) {
        ApiManager.shared.deleteAccount(
            completion: { result in
                switch result {
                case let .success(user):
                    UserDefaultsManager.shared.removeUserAuthData()
                    DispatchQueue.main.async {
                        completion(.success(user))
                    }
                case let .failure(failure):
                    DispatchQueue.main.async {
                        completion(.failure(failure))
                    }
                }
            },
            token: token
        )
    }

//    func updateTokens() {
//        guard let refreshToken = UserDefaults.standard.string(forKey: UserKeys.refreshToken.rawValue) else {
//            return
//        }
//        print("Начинаю обновление токенов")
//
//        ApiManager.shared.updateAccessTokenByRefresh(
//            completion: { result in
//                switch result {
//                case let .success(authData):
//                    print("Устанавливаю новые токены: \(authData)")
//                    UserDefaultsManager.shared.saveUserAuthData(authData: authData)
//                case let .failure(error):
//                    switch error.code {
//                    case 401:
//                        // TODO: чистить локальное хранилище. т к истек рефреш
//                        print("[Debug]: resresh is expired")
//                        UserDefaultsManager.shared.removeUserAuthData()
//                    default:
//                        break
//                    }
//                }
//            },
//            refreshToken: refreshToken
//        )
//    }

//    func updateTokens(completion: @escaping (_ result: Bool?) -> Void) {
//        guard let refreshToken = UserDefaults.standard.string(forKey: UserKeys.refreshToken.rawValue) else { return }
//        print("Начинаю обновление токенов")
//
//        ApiManager.shared.updateAccessTokenByRefresh(
//            completion: { result in
//                switch result {
//                case let .success(authData):
//                    print("Устанавливаю новые токены: \(authData)")
//                    UserDefaultsManager.shared.saveUserAuthData(authData: authData)
//                    completion(true)
//                case let .failure(error):
//                    switch error.code {
//                    case 401:
//                        // TODO: чистить локальное хранилище. т к истек рефреш
//                        print("[Debug]: resresh is expired")
//                        UserDefaultsManager.shared.removeUserAuthData()
//                        completion(false)
//                    default:
//                        break
//                    }
//                }
//            },
//            refreshToken: refreshToken
//        )
//    }

    func logout() {
        UserDefaultsManager.shared.removeUserAuthData()
		CoreDataManager.shared.deleteAllFavouritesExcursions()
    }
}
