//
//  User.swift
//  PROGulky
//
//  Created by Сергей Киселев on 02.12.2022.
//

// MARK: - User

import UIKit

// MARK: - User

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let image: String?
    let role: Role
}

// MARK: - UserImageForPost

struct UserImageForPost {
    let image: UIImage
}

// MARK: - UserImageAfterPost

struct UserImageAfterPost: Codable {
    let fileName: String
}

// MARK: - Role

struct Role: Codable {
    let id: Int
    let value: String
    let description: String
}

// MARK: - AuthData

struct AuthData: Codable {
    let accessToken: String?
    let refreshToken: String?
    let refreshExpiresAt: String?
}

// MARK: - LoginDTO

struct LoginDTO {
    let email: String
    let password: String
}

// MARK: - RegistrationDTO

struct RegistrationDTO {
    let email: String
    let password: String
    let nickname: String
}

// MARK: - UserData

// TODO: замечание Олега (роль мог бы еще отдельно прописать enum-ом с типом стринг. было бы красивое)
struct UserData {
    let name: String
    let email: String
    let token: String
    let role: String
	let image: String?
}
