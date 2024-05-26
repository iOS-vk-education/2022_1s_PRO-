//
//  TextConstants.swift
//  PROGulky
//
//  Created by Сергей Киселев on 08.11.2022.
//

import Foundation

struct GlobalConstants {
	static let baseURL = "http://81.31.245.130:1915"
}
let baseURL = GlobalConstants.baseURL

// MARK: - TextConstantsProfile

struct TextConstantsProfile {
    static let titleProfile = "Профиль"
    static let titleAccount = "Аккаунт"
    static let titleOthers = "Другое"
    static let titleBeGuide = "Стать экскурсоводом"
    static let titlePersonalData = "Персональные данные"
    static let titleAchievements = "Достижения"
    static let titleHistory = "История прогулок"
    static let titleContactUs = "Свяжитесь с нами"
    static let titlePrivacyPolicy = "Политика конфиденциальности"
    static let titleSignOut = "Выйти из аккаунта"
    static let deleteAccount = "Удалить аккаунт"
    static let titleUserName = "Имя пользователя"
    static let titleUserStatus = "статус"
    static let contactUsMessageTitle = "PROгулки отзыв"
    static let beGuideMessage = "Запрос: изменение статуса на гида"
    static let contactUsMail = "serge2000k@gmail.com"
    static let changeTheme = "Сменить тему"
}

// MARK: - TextConstantsLogin

struct TextConstantsLogin {
    static let titleProgramName = "PROгулки"
    static let titleEmail = "Электронная почта"
    static let titlePassword = "Пароль"
    static let titleSignIn = "Войти"
    static let titleSignUp = "Зарегистрироваться"
    static let titleRestore = "Забыли пароль?"
    static let titleNavBar = "Вход"
}

// MARK: - TextConstantsSignUp

struct TextConstantsSignUp {
    static let titleTop = "Регистрация"
    static let titleEmail = "Электронная почта"
    static let titlePassword = "Пароль"
    static let titlePasswordSecond = "Повторите пароль"
    static let titleSignIn = "уже есть аккаунт, войти"
    static let titleSignUp = "Зарегистрироваться"
    static let titleName = "Имя"
}
