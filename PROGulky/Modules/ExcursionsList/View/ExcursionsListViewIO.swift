//
//  ExcursionsListViewIO.swift
//  PROGulky
//
//  Created by SemyonPyatkov on 31/10/2022.
//

import Foundation

// MARK: - ExcursionsListViewOutput

protocol ExcursionsListViewOutput: AnyObject {
    func didLoadView()

    func item(for index: Int) -> ExcursionViewModel

    func itemsCount() -> Int

    func didSelectCell(at indexPath: IndexPath)

    func didRepeatButtonTapped()

    func didAddExcursionButtonTapped()

    func didTextTyping(with text: String)

    func didClearSearchBar()

    // Методы фильра
    func getDistanceFilterButtons() -> [FilterButtonViewModel] // Получить параметры фильтра "Длина маршрута"

    func didDistanceFilterButtonTapped(with title: String) // Нажата кнопка фильтра "Длина маршрута" (в нее передано название нажатой кнопки)

    func getTimesFilterButtons() -> [FilterButtonViewModel] // Получить параметры фильтра "Время прогулки"

    func didTimeFilterButtonTapped(with title: String) // Нажата кнопка фильтра "Время прогулки"

    func getRatingFilterButtons() -> [FilterButtonViewModel] // Получить параметры фильтра "Рейтинг"

    func didRatingFilterButtonTapped(with title: String) // Нажата кнопка фильтра "Рейтинг"

    func didFilterSubmitButtonTapped() // Нажали на кнопку "Применить" в фильтре
	func reload() 
}

// MARK: - ExcursionsListFiltersViewOutput

protocol ExcursionsListFiltersViewOutput: AnyObject {
    func getDistanceFilterButtons() -> [FilterButtonViewModel]

    func didDistanceFilterButtonTapped(with title: String)

    func getTimesFilterButtons() -> [FilterButtonViewModel]

    func didTimeFilterButtonTapped(with title: String)

    func getRatingFilterButtons() -> [FilterButtonViewModel]

    func didRatingFilterButtonTapped(with title: String)

    func didSubmitButtonTapped()
}

// MARK: - ExcursionsListViewInput

protocol ExcursionsListViewInput: AnyObject {
    func reloadView() // Перезагрузка данныx в таблице

    func startLoader() // Запустить крутилку с загрузкой

    func stopLoader() // Остановить крутилку с загрузкой

    func showErrorView(with error: Error) // Показать сообщение с ошибкой

    func showAuthView() // Показать сообщение о необходимости авторизации

    func hideErrorView()

    func configureGreetingMessage(with user: GreetingViewModel) // Конфигурация вьюхи приветствия

    func showFilterButtonBadge(with text: String) // Показать бейдж

    func hideFilterButtonBadge() // Скрыть бейдж с количеством выбранных фильтров

    func showEmptyListView() // Показать сообщение о том, что список пуст

    func hideEmptyListView() // Скрыть сообщение о том, что список пуст
}
