//
//  UserInfoHeaderDisplayDataFactory.swift
//  PROGulky
//
//  Created by Сергей Киселев on 22.12.2022.
//

import Foundation

// MARK: - UserInfoHeaderDisplayDataFactoryProtocol

protocol UserInfoHeaderDisplayDataFactoryProtocol {
    func getDisplayData() -> UserInfoHeader.DisplayData
}

// MARK: - UserInfoHeaderDisplayDataFactory

final class UserInfoHeaderDisplayDataFactory: UserInfoHeaderDisplayDataFactoryProtocol {
    func getDisplayData() -> UserInfoHeader.DisplayData {
        let data = UserService.shared.userData
		let displayData = UserInfoHeader.DisplayData(username: data.name, status: "статус - " + data.role, image: data.image)
        return displayData
    }
}
