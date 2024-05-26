//
//  ExcursionsListViewController.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 31/10/2022.
//

import UIKit
import SnapKit
import Lottie

// MARK: - ExcursionsListViewController

final class ExcursionsListViewController: CustomViewController {
    var output: ExcursionsListViewOutput!

    private let filterBadgeButton = FilterBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 22))
    private var greetingMessageView = GreetingMessageView()
    private let searchController = UISearchController()
    private var excursionsTable = UITableView(frame: .zero, style: .plain)
	private let refreshControl = UIRefreshControl()
    private let emptyListMessageView = ExcursionsListMessageView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.didLoadView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.didLoadView()
		let rightBarButtonAddExcursionItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(didTapAddButton)
		)

		let rightBarFilterButtonItem = UIBarButtonItem(customView: filterBadgeButton)
		filterBadgeButton.addTarget(self, action: #selector(handleShowBottomSheet), for: .touchUpInside)

		var rightButtonItems = [rightBarFilterButtonItem]
		if UserDefaultsManager.shared.isGuide {
			rightButtonItems.append(rightBarButtonAddExcursionItem)
		}
		navigationItem.rightBarButtonItems = rightButtonItems
    }

    private func setupGreetingMessaageText(with viewModel: GreetingViewModel) {
        greetingMessageView.set(viewModel: viewModel)
    }

    private func setupUI() {
        setupSearchController()
        setupEmptyListMessageView()
        setupNavBar()
        setupTableView()
    }

    func reload() {
        excursionsTable.reloadData()
		excursionsTable.refreshControl?.endRefreshing()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Найти маршрут"
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")

        definesPresentationContext = true
    }

    private func setupEmptyListMessageView() {
        excursionsTable.addSubview(emptyListMessageView)
        emptyListMessageView.isHidden = true
        setupEmptyListMessageViewConstraints()
    }

    // Настройка нав бара
    private func setupNavBar() {
//        navigationItem.title = ExcursionsListConstants.NavBar.title
        navigationController?.view.backgroundColor = ExcursionsListConstants.NavBar.backgroundColor

        // TODO: Сделать показ только для пользователя с определенной ролью
        let rightBarButtonAddExcursionItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )

        let rightBarFilterButtonItem = UIBarButtonItem(customView: filterBadgeButton)
        filterBadgeButton.addTarget(self, action: #selector(handleShowBottomSheet), for: .touchUpInside)

		var rightButtonItems = [rightBarFilterButtonItem]
		if UserDefaultsManager.shared.isGuide {
			rightButtonItems.append(rightBarButtonAddExcursionItem)
		}
        navigationItem.rightBarButtonItems = rightButtonItems

        let leftBarButtonItem = UIBarButtonItem(customView: greetingMessageView)
        navigationItem.leftBarButtonItem = leftBarButtonItem

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    private var bottomSheetTransitioningDelegate: BottomSheetTransitioningDelegate?

    @objc
    private func handleShowBottomSheet() {
        let viewController = ExcursionsListFiltersViewController(initialHeight: 450, delegate: self)
        bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate(factory: self)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = bottomSheetTransitioningDelegate
        present(viewController, animated: true, completion: nil)
    }

    @objc
    private func didTapAddButton() {
        output.didAddExcursionButtonTapped()
    }

    // Настройка таблицы с экскурсиями
    private func setupTableView() {
        view.addSubview(excursionsTable)
        excursionsTable.backgroundColor = .prog.Dynamic.background
        excursionsTable.keyboardDismissMode = .onDrag
		excursionsTable.refreshControl = refreshControl
        excursionsTable.layoutMargins = UIEdgeInsets(
            top: ExcursionsListConstants.Screen.paddingTop,
            left: ExcursionsListConstants.Screen.padding,
            bottom: ExcursionsListConstants.Screen.paddingBottom,
            right: ExcursionsListConstants.Screen.padding
        )
        excursionsTable.separatorStyle = .none

        setTableViewDelegate()
        excursionsTable.register(ExcursionCell.self, forCellReuseIdentifier: ExcursionsListConstants.ExcursionCell.reuseId)
        setTableViewConstraints()

		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

	@objc
	private func refresh() {
		output.reload()
	}

    private func setTableViewDelegate() {
        excursionsTable.delegate = self
        excursionsTable.dataSource = self
    }

    private func setTableViewConstraints() {
        excursionsTable.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    private func setupEmptyListMessageViewConstraints() {
        emptyListMessageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: ExcursionsListFiltersViewOutput

extension ExcursionsListViewController: ExcursionsListFiltersViewOutput {
    func didDistanceFilterButtonTapped(with title: String) {
        output.didDistanceFilterButtonTapped(with: title)
    }

    func didTimeFilterButtonTapped(with title: String) {
        output.didTimeFilterButtonTapped(with: title)
    }

    func didRatingFilterButtonTapped(with title: String) {
        output.didRatingFilterButtonTapped(with: title)
    }

    func didSubmitButtonTapped() {
        performDismissal(animated: true) // Скрыть боттом шит
        output.didFilterSubmitButtonTapped()
    }

    func getDistanceFilterButtons() -> [FilterButtonViewModel] {
        output.getDistanceFilterButtons()
    }

    func getTimesFilterButtons() -> [FilterButtonViewModel] {
        output.getTimesFilterButtons()
    }

    func getRatingFilterButtons() -> [FilterButtonViewModel] {
        output.getRatingFilterButtons()
    }
}

// MARK: ExcursionsListViewInput

extension ExcursionsListViewController: ExcursionsListViewInput {
    func showEmptyListView() {
        emptyListMessageView.isHidden = false
    }

    func hideEmptyListView() {
        emptyListMessageView.isHidden = true
    }

    func showFilterButtonBadge(with text: String) {
        filterBadgeButton.setupTextToBadgeLabel(with: text)
        filterBadgeButton.showBadge()
    }

    func hideFilterButtonBadge() {
        filterBadgeButton.hideBadge()
    }

    func configureGreetingMessage(with viewModel: GreetingViewModel) {
        setupGreetingMessaageText(with: viewModel)
    }

    func hideErrorView() {
        hideActivity()
    }

    func showErrorView(with error: Error) {
        showHUD(with: error)
        hideActivity()
    }

    func reloadView() {
        reload()
    }

    func startLoader() {
        showActivity()
    }

    func stopLoader() {
        hideActivity()
    }

    func showAuthView() {
        let notLoginAlert = UIAlertController(title: "Вы не авторизованы! Необходимо войти в Ваш аккаунт", message: "", preferredStyle: .alert)
        notLoginAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            notLoginAlert.dismiss(animated: true, completion: nil)
        }))
        present(notLoginAlert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource

extension ExcursionsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.itemsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExcursionsListConstants.ExcursionCell.reuseId) as? ExcursionCell else {
            return UITableViewCell()
        }
        let excursion = output.item(for: indexPath.row)
        cell.set(excursion: excursion)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ExcursionsListConstants.ExcursionCell.height
    }
}

// MARK: UITableViewDelegate

extension ExcursionsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.didSelectCell(at: indexPath)
    }
}

// MARK: ErrorViewDelegate

extension ExcursionsListViewController: ErrorViewDelegate {
    func didRepeatButtonTapped() {
        output.didRepeatButtonTapped()
    }
}

// MARK: UISearchResultsUpdating

extension ExcursionsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            if text.isEmpty {
                output.didClearSearchBar()
            } else {
                output.didTextTyping(with: text)
            }
        }
    }
}

// MARK: BottomSheetPresentationControllerFactory

extension ExcursionsListViewController: BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController {
        .init(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            dismissalHandler: self
        )
    }
}

// MARK: BottomSheetModalDismissalHandler

extension ExcursionsListViewController: BottomSheetModalDismissalHandler {
    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
    }
}
