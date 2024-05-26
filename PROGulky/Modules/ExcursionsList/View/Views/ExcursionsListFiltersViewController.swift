//
//  ExcursionsListFiltersViewController.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 30.03.2023.
//

import UIKit

// MARK: - ExcursionsListFiltersConstants

private struct ExcursionsListFiltersConstants {
    enum StackView {
        static let height: CGFloat = 35
        static let topOffset: CGFloat = 15
        static let widthOffset: CGFloat = -32
        static let spacing: CGFloat = 15
    }

    enum DistanceLabel {
        static let text: String = "Длина маршрута"
        static let inset: CGFloat = 20
    }

    enum TimeLabel {
        static let text: String = "Время прогулки"
        static let offset: CGFloat = 20
    }

    enum RatingLabel {
        static let text: String = "Рейтинг"
        static let offset: CGFloat = 20
    }

    enum SubmitButton {
        static let height: CGFloat = 50
        static let cornerRadius: CGFloat = 12
        static let text: String = "Применить"
    }
}

// MARK: - ExcursionsListFiltersViewController

final class ExcursionsListFiltersViewController: UIViewController {
    var output: ExcursionsListFiltersViewOutput!

    var distances: [FilterButtonViewModel] // вью модель (опций) фильтра по "Дистанции"
    var times: [FilterButtonViewModel]
    var ratings: [FilterButtonViewModel]

    private var selectedDistanceButton: ChipsButton? // Выбранная кнопка фильтра длины
    private var selectedTimeButton: ChipsButton? // Выбранная кнопка фильтра продолжительности
    private var selectedRatingButton: ChipsButton? // Выбранная кнопка фильтра рейтинга

    // MARK: - Subviews

    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        label.text = ExcursionsListFiltersConstants.DistanceLabel.text
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        label.text = ExcursionsListFiltersConstants.TimeLabel.text
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 21.0)
        label.text = ExcursionsListFiltersConstants.RatingLabel.text
        return label
    }()

    private let _scrollView = UIScrollView()
    private let distanceStackView = UIStackView() // Стек вью фильтра длины
    private let timeStackView = UIStackView() // Стек вью фильтра длительности
    private let ratingStackView = UIStackView() // Стек вью фильтра

    private let submitButton = UIButton()
	private let containerView = UIView()
    private var currentHeight: CGFloat {
        didSet {
            updatePreferredContentSize()
        }
    }

    // MARK: - Init

    init(initialHeight: CGFloat, delegate: ExcursionsListFiltersViewOutput) {
        output = delegate
        distances = output.getDistanceFilterButtons()
        times = output.getTimesFilterButtons()
        ratings = output.getRatingFilterButtons()

        currentHeight = initialHeight
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewCoontroller

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        updatePreferredContentSize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.setNeedsLayout()
    }

    // MARK: - Setup

    private func setupSubviews() {
        view.backgroundColor = .prog.Dynamic.background
        view.addSubview(_scrollView)
//		_scrollView.addSubview(containerView)
		_scrollView.contentInset.top = -90
        configureScrollView()
        configureDistanceLabel()
        configureDistanceStackView()
        configureTimeLabel()
        configureTimeStackView()
        configureRatingLabel()
        configureRatingStackView()
        confugureSubmitButton()
    }

    private func configureScrollView() {
        _scrollView.alwaysBounceVertical = true
        setScrollViewConstratints()
    }

    private func configureDistanceLabel() {
        _scrollView.addSubview(distanceLabel)
        setDistanceLabelConstraint()
    }

    private func configureTimeLabel() {
        _scrollView.addSubviews(timeLabel)
        setTimeLabelConstraint()
    }

    private func configureRatingLabel() {
        _scrollView.addSubview(ratingLabel)
        setRatingLabelConstraint()
    }

    private func configureDistanceStackView() {
        _scrollView.addSubview(distanceStackView)
        distanceStackView.axis = .horizontal
        distanceStackView.distribution = .fillEqually
        distanceStackView.spacing = ExcursionsListFiltersConstants.StackView.spacing

        addButtonToStackView(
            for: distanceStackView,
            items: distances,
            selectedTmpButton: &selectedDistanceButton,
            function: #selector(filterButtonTapped)
        )
        setStackViewConstratins()
    }

    private func configureTimeStackView() {
        _scrollView.addSubviews(timeStackView)
        timeStackView.axis = .horizontal
        timeStackView.distribution = .fillEqually
        timeStackView.spacing = ExcursionsListFiltersConstants.StackView.spacing

        addButtonToStackView(
            for: timeStackView,
            items: times,
            selectedTmpButton: &selectedTimeButton,
            function: #selector(timeButtonTapped)
        )
        setTimeStackViewConstratins()
    }

    private func configureRatingStackView() {
        _scrollView.addSubview(ratingStackView)
        ratingStackView.axis = .horizontal
        ratingStackView.distribution = .fillEqually
        ratingStackView.spacing = ExcursionsListFiltersConstants.StackView.spacing

        addButtonToStackView(
            for: ratingStackView,
            items: ratings,
            selectedTmpButton: &selectedRatingButton,
            function: #selector(ratingButtonTapped)
        )
        setRatingStackViewConstraints()
    }

    private func confugureSubmitButton() {
        _scrollView.addSubview(submitButton)

        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .prog.Dynamic.primary
        submitButton.layer.cornerRadius = ExcursionsListFiltersConstants.SubmitButton.cornerRadius
        submitButton.setTitle(ExcursionsListFiltersConstants.SubmitButton.text, for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)

        setSubmitButtonConstraints()
    }

    @objc
    func submitButtonTapped() {
        output.didSubmitButtonTapped()
    }

    // MARK: Constraints

    private func setScrollViewConstratints() {
        _scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//			make.center.equalToSuperview()
        }
    }

    private func setDistanceLabelConstraint() {
        distanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(ExcursionsListFiltersConstants.DistanceLabel.inset)
            make.left.right.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
        }
    }

    private func setTimeLabelConstraint() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceStackView.snp.bottom).offset(ExcursionsListFiltersConstants.TimeLabel.offset)
            make.left.right.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
        }
    }

    private func setRatingLabelConstraint() {
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(timeStackView.snp.bottom).offset(ExcursionsListFiltersConstants.RatingLabel.offset)
            make.left.right.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
        }
    }

    private func setStackViewConstratins() {
        distanceStackView.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(ExcursionsListFiltersConstants.StackView.topOffset)
            make.width.equalToSuperview().offset(ExcursionsListFiltersConstants.StackView.widthOffset)
            make.left.right.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
            make.height.equalTo(ExcursionsListFiltersConstants.StackView.height)
        }
    }

    private func setTimeStackViewConstratins() {
        timeStackView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(ExcursionsListFiltersConstants.StackView.topOffset)
            make.width.equalToSuperview().offset(ExcursionsListFiltersConstants.StackView.widthOffset)
            make.left.right.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
            make.height.equalTo(ExcursionsListFiltersConstants.StackView.height)
        }
    }

    private func setRatingStackViewConstraints() {
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(ExcursionsListFiltersConstants.StackView.topOffset)
            make.width.equalToSuperview().offset(ExcursionsListFiltersConstants.StackView.widthOffset)
            make.left.right.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
            make.height.equalTo(ExcursionsListFiltersConstants.StackView.height)
        }
    }

    private func setSubmitButtonConstraints() {
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
            make.right.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
            make.height.equalTo(ExcursionsListFiltersConstants.SubmitButton.height)
        }
    }

    private func addButtonToStackView(for stackView: UIStackView, items: [FilterButtonViewModel], selectedTmpButton: inout ChipsButton?, function: Selector) {
        for item in items {
            let button = ChipsButton()
            if item.isSelected {
                button.setSelectedColor()
                selectedTmpButton = button
            }
            button.setTitle(item.title, for: .normal)
            button.addTarget(self, action: function, for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    @objc
    func filterButtonTapped(selectableButton: ChipsButton) {
        guard let title = selectableButton.titleLabel?.text else { return }
        output.didDistanceFilterButtonTapped(with: title)

        selectedDistanceButton?.setDefaultColor() // Выбранная (старая) становится серой
        selectableButton.setSelectedColor() // Выбираемая (сейчас нажатая) становится синей
        selectedDistanceButton = selectableButton
    }

    @objc
    func timeButtonTapped(selectableButton: ChipsButton) {
        guard let title = selectableButton.titleLabel?.text else { return }
        output.didTimeFilterButtonTapped(with: title)

        selectedTimeButton?.setDefaultColor()
        selectableButton.setSelectedColor()
        selectedTimeButton = selectableButton
    }

    @objc
    func ratingButtonTapped(selectableButton: ChipsButton) {
        guard let title = selectableButton.titleLabel?.text else { return }
        output.didRatingFilterButtonTapped(with: title)

        selectedRatingButton?.setDefaultColor()
        selectableButton.setSelectedColor()
        selectedRatingButton = selectableButton
    }

    // MARK: - Private methods

    private func updatePreferredContentSize() {
        _scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        preferredContentSize = _scrollView.contentSize
    }
}
