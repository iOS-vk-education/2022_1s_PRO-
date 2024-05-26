//
//  ExcursionsListPresenter.swift
//  PROGulky
//
//  Created by SemyonPyatkov on 31/10/2022.
//

import Foundation

// MARK: - BaseFilter

protocol BaseFilter {
    var isDefault: Bool { get }
}

// MARK: - DistanceFilter

enum DistanceFilter: String, BaseFilter {
    case all = "Все"
    case from1To3 = "1-3 км"
    case from3To6 = "3-6 км"
    case from6To10 = "6-10 км"

    var isDefault: Bool {
        self == .all
    }
}

// MARK: - TimeFilter

enum TimeFilter: String, BaseFilter {
    case all = "Все"
    case from30mTo60m = "30-60 м"
    case from1hTo2h = "1-2 ч"
    case from2hTo3h = "2-3 ч"

    var isDefault: Bool {
        self == .all
    }
}

// MARK: - RatingFilter

enum RatingFilter: String, BaseFilter {
    case all = "Все"
    case high = "Лучшее"
    case middle = "Хорошее"
    case low = "3.5-4.0"

    var isDefault: Bool {
        self == .all
    }
}

// MARK: - ExcursionsListPresenter

final class ExcursionsListPresenter {
    // MARK: - Public Properties

    weak var view: ExcursionsListViewInput!
    weak var moduleOutput: ExcursionsListModuleOutput?

    // MARK: - Private Properties

    private let interactor: ExcursionsListInteractorInput
    private let router: ExcursionsListRouterInput

    private let factory = ExcursionsListDisplayDataFactory()
    private var excursions: [PreviewExcursion] = []

    // Параметры для фильтра "Длина маршрута"
    private let distances: [DistanceFilter] = [.all, .from1To3, .from3To6, .from6To10]
    private var selectedDistance: DistanceFilter = .all

    // Параметры для фильтра "Время прогулки"
    private let times: [TimeFilter] = [.all, .from30mTo60m, .from1hTo2h, .from2hTo3h]
    private var selectedTime: TimeFilter = .all

    // Параметры для фильтра "Рейтинг"
    private let ratings: [RatingFilter] = [.all, .middle, .high]
    private var selectedRating: RatingFilter = .all

    // MARK: - Lifecycle

    init(interactor: ExcursionsListInteractorInput,
         router: ExcursionsListRouterInput,
         moduleOutput: ExcursionsListModuleOutput) {
        self.interactor = interactor
        self.router = router
        self.moduleOutput = moduleOutput
    }
}

extension ExcursionsListPresenter: ExcursionsListModuleInput {
}

// MARK: ExcursionsListViewOutput

extension ExcursionsListPresenter: ExcursionsListViewOutput {
	func reload() {
		LocationManager.shared.requestLocation()
		interactor.loadExcursionsList()
	}
    func didDistanceFilterButtonTapped(with title: String) {
        guard let selectedParameter = DistanceFilter(rawValue: title) else { return }
        selectedDistance = selectedParameter
    }

    func didTimeFilterButtonTapped(with title: String) {
        guard let selectedParameter = TimeFilter(rawValue: title) else { return }
        selectedTime = selectedParameter
    }

    func didRatingFilterButtonTapped(with title: String) {
        guard let selectedParameter = RatingFilter(rawValue: title) else { return }
        selectedRating = selectedParameter
    }

    func didFilterSubmitButtonTapped() {
        interactor.addDistanceFilterParameter(parameter: selectedDistance)
        interactor.addTimeFilterParameter(parameter: selectedTime)
        interactor.addRatingFilterParameter(parameter: selectedRating)
        interactor.loadExcursionsList()
        view.startLoader()
        configureCountSelectedFilters()
    }

    // Вычислить количество выбранных фильтров и показать это количество во вью
    private func configureCountSelectedFilters() {
        let selectedFilters = [selectedDistance, selectedTime, selectedRating] as [BaseFilter]
        let selectedFiltersCount = selectedFilters.reduce(0) { current, filter in
            let increment = !filter.isDefault ? 1 : 0
            return current + increment
        }

        if selectedFiltersCount != 0 {
            view.showFilterButtonBadge(with: "\(selectedFiltersCount)")
        } else {
            view.hideFilterButtonBadge()
        }
    }

    func getDistanceFilterButtons() -> [FilterButtonViewModel] {
        distances.map { [weak self] distance in
            FilterButtonViewModel(title: distance.rawValue, isSelected: distance == self?.selectedDistance)
        }
    }

    func getTimesFilterButtons() -> [FilterButtonViewModel] {
        times.map { [weak self] time in
            FilterButtonViewModel(title: time.rawValue, isSelected: time == self?.selectedTime)
        }
    }

    func getRatingFilterButtons() -> [FilterButtonViewModel] {
        ratings.map { [weak self] rating in
            FilterButtonViewModel(title: rating.rawValue, isSelected: rating == self?.selectedRating)
        }
    }

    func didTextTyping(with text: String) {
        interactor.startSearchExcursions(by: text)
    }

    func didClearSearchBar() {
        interactor.clearSearchTextQueryParameter()
        interactor.loadExcursionsList()
    }

    func didAddExcursionButtonTapped() {
        guard UserAuthService.shared.isLogged else {
            view.showAuthView()
            return
        }
        moduleOutput?.excursionsListModuleWantsToOpenAddExcursion()
    }

    func didRepeatButtonTapped() {
        interactor.loadExcursionsList()
    }

    func didSelectCell(at indexPath: IndexPath) {
        guard UserAuthService.shared.isLogged else {
            view.showAuthView()
            return
        }
        moduleOutput?.excursionsListModuleWantsToOpenDetailModule(excursionId: excursions[indexPath.row].id)
    }

    func didLoadView() {
        interactor.loadExcursionsList()
        interactor.loadUserInstance()
        view.startLoader() // Запуск анимации лоадера
    }

    func item(for index: Int) -> ExcursionViewModel {
        factory.getExcursionViewModel(for: excursions[index])
    }

    func itemsCount() -> Int {
        excursions.count
    }
}

// MARK: ExcursionsListInteractorOutput

extension ExcursionsListPresenter: ExcursionsListInteractorOutput {
    func showActivity() {
        view.startLoader()
    }

    func getNetworkError() {
        excursions = []

        // TODO: брать ошибки с API
        let error = NSError(domain: "Ошибка сети", code: 400)

        view.showErrorView(with: error)
        view.reloadView() // Перезагрузить тейбл вью
    }

    func didLoadExcursionsList(excursions: PreviewExcursions) {
        self.excursions = excursions
        view.hideErrorView() // Скрыть сообщение об ошибках
        self.excursions.isEmpty ? view.showEmptyListView() : view.hideEmptyListView()
        view.reloadView() // Перезагрузить тейбл вью
        view.stopLoader() // Выключить анимацию лоадера
    }

    func didLoadUserInstance(user: UserData?) {
        let viewModel = factory.getGreetingViewModel(for: user)
        view.configureGreetingMessage(with: viewModel)
    }
}
