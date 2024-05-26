//
//  Constants.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 11.11.2022.
//

import UIKit

struct ExcursionsListConstants {
    // Константы для всего экрана (падинги, цвет фотна и т. д.)
    enum Screen {
        static let padding: CGFloat = 12
        static let paddingTop: CGFloat = 0
        static let paddingBottom: CGFloat = 0
        static let backgroundColor = UIColor.prog.Dynamic.background
    }

    enum NavBar {
        static let title: String = "Маршруты" // Название экрана
        static let backgroundColor = UIColor.prog.Dynamic.background
    }

    enum GreetingMessage {
        static let height: CGFloat = 20
        static let offset: CGFloat = 5

        static let labelFontSize = 20.0
        static let buttonFontSize = 20.0

        static let labelColor: UIColor = .prog.Dynamic.greetingText
        static let buttonColor: UIColor = .prog.Dynamic.primary

        static let labelTextIsLoggedUser = "Привет,"
        static let labelTextIsNotLoggedUser = "Привет!"
        static let buttonTextIsNotLoggedUser = "Войди в аккаунт!"
    }

    enum SearchTextField {
        static let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let cornerRadius: CGFloat = 14
        static let offset: CGFloat = 30
        static let shadowRadius: CGFloat = 9
        static let fontSize: CGFloat = 13
        static let height: CGFloat = 54
        static let shadowOpacity: Float = 0.4
        static let backgroundColor: UIColor = UIColor.prog.Dynamic.lightBackground
        static let placeholderColor: UIColor = UIColor.prog.Dynamic.lightText
        static let textColor: UIColor = UIColor.prog.Dynamic.text
        static let shadowColor: UIColor = UIColor.prog.Dynamic.shadow
    }

    enum FilterButton {
        static let title: String = "Фильтр"
        static let icon: String = "slider.horizontal.3"
        static let padding: CGFloat = 6
        static let color: UIColor = .prog.Dynamic.primary
        static let width: CGFloat = 40
    }

    enum SearchButton {
        static let icon: String = "magnifyingglass"
        static let color: UIColor = .prog.Dynamic.primary
        static let width: CGFloat = 40
    }

    enum TableView {
        static let offset = 15
    }

    enum FavoritesExcursionsCell {
        static let reuseId = "FavoritesExcursionCell"
    }

    enum ExcursionCell {
        static let reuseId = "ExcursionCell" // Идентификатор ячейки

        static let height: CGFloat = 155 // Высота ячейки
        static let contentIndent: CGFloat = 20 // Отступ контента от картинки
        static let cornerRadius: CGFloat = 16 // Скругление у ячейки

        static let shadowRadius: CGFloat = 9 // Радиус тени
        static let shadowOpacity: Float = 0.4 // Прозрачность тени
        static let shadowColor: UIColor = UIColor.prog.Dynamic.shadow

        enum ContentView {
            static let marginTop: CGFloat = 8
            static let marginBottom: CGFloat = 8
            static let marginLeft: CGFloat = 10
            static let marginRight: CGFloat = 10
        }

        enum Image {
            static let cornerRadius: CGFloat = 10 // Радиус скургления картинки экскурсии
            static let height: CGFloat = 110 // Высота картинки
            static let aspectRatio: CGFloat = 14 / 9 // Соотношение сторон картинки
        }

        enum Title {
            static let fontSize: CGFloat = 15
            static let fontWeight = UIFont.Weight.semibold // Толщина заголовка
            static let offset: CGFloat = 1
        }

        enum RatingImage {
            static let offset: CGFloat = 2
            static let name: String = "star.fill" // Иконка рейтинга
            static let height: CGFloat = 16
            static let color: UIColor = .prog.Dynamic.rating
            static let aspectRatio: CGFloat = 1.1 // отношение высоты к ширине
        }

        enum RatingLabel {
            static let inset: CGFloat = 20 // Отступ от верха
            static let fontSize: CGFloat = 13 // Размер текста рейтинга
            static let fontWeight = UIFont.Weight.medium // Толщина текста рейтинга
            static let textColor: UIColor = .gray // Цвет текста рейтинга
        }

        enum Parameters {
            static let offset: CGFloat = 5
            static let fontSize: CGFloat = 13 // Размер текста параметров
            static let fontWeight = UIFont.Weight.medium // Толщина текста параметров
            static let textColor: UIColor = .gray // Цвет текста параметров
        }

        enum OwnerLabel {
            static let bottomInset = 18
            static let fontSize: CGFloat = 13
            static let fontWeight = UIFont.Weight.light
            static let textColor: UIColor = .gray // Цвет текста параметров
        }

        enum OwnerImage {
            static let height: CGFloat = 20
            static let width: CGFloat = 20
            static let cornerRadius = height / 2
            static let bottomInset: CGFloat = 15
        }
    }

    enum EmptyListAnimationView {
        static let labelText: String = "По запросу ничего не найдено"
        static let labelFont: UIFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        static let height: CGFloat = 150
        static let width: CGFloat = 150
        static let offset: CGFloat = -60
    }

    enum Api {
        static let baseURL: String = GlobalConstants.baseURL
		static let imageURL: String = "\(baseURL)/images/excursions"
		static let ownerImageURL: String = "\(baseURL)/images/users"
    }
}
