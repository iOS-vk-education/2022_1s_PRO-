//
//  AddExcursionViewController.swift
//  PROGulky
//
//  Created by SemyonPyatkov on 31/10/2022.
//

import UIKit
import SnapKit
import PhotosUI

// MARK: - AddExcursionViewController

final class AddExcursionViewController: UIViewController {
    var output: AddExcursionViewOutput!

    private var excursionName: String?
    private var excursionDescription: String?
    private var image: UIImage?
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)
	private var isEditingTable = false

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		SelectedPlacesManager.sharedInstance.removeAll()
	}

    private func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = .prog.Dynamic.background2

        configureNavBar()
        configureTableView()
        configureKeyBoard()
    }

    private func configureKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configureNavBar() {
        navigationItem.title = AddExcursionConstants.NavBar.title
        navigationController?.view.backgroundColor = AddExcursionConstants.NavBar.backgroundColor

        let rightBarButtonItem = UIBarButtonItem(
            title: AddExcursionConstants.NavBar.rightBarButtonItemText,
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc
    private func saveButtonTapped() {
        guard
            let name = excursionName,
            !name.isEmpty,
            let description = excursionDescription,
            !description.isEmpty,
            output.selectedPlacesCount >= 2,
            let image else {

			let errorAlert = UIAlertController(
				title: "Заполните все поля",
				message: "Должно быть как минимум 2 точки маршрута",
				preferredStyle: .alert
			)
			errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
				errorAlert.dismiss(animated: true, completion: nil)
			}))
			present(errorAlert, animated: true, completion: nil)
            return
        }
        output.didTapSaveButton(name: name, description: description, image: image)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if view.frame.origin.y == 0, presentedViewController == nil {
                view.frame.origin.y -= keyboardHeight / 2
            }
        }
    }

    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
    }

    private func didTapAddImageButton() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func configureTableView() {
        setTableViewDelegate()

        tableView.backgroundColor = UIColor.prog.Dynamic.background

        tableView.register(SelectedPlaceCell.self, forCellReuseIdentifier: AddExcursionConstants.TableView.SelectedPlaceCell.reuseId)
        tableView.register(AddPlaceCell.self, forCellReuseIdentifier: AddExcursionConstants.TableView.AddPlaceButtonCell.reuseId)
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(AddExcursionDescriptionCell.self, forCellReuseIdentifier: "AddExcursionDescriptionCell")
        tableView.register(AddExcursionTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: "HeaderView")
    }

    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupConstraints() {
        setTableViewConstraints()
    }

    private func setTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

// MARK: AddExcursionViewInput

extension AddExcursionViewController: AddExcursionViewInput {
	func reloadPlaces() {
		if output.selectedPlacesCount == 0 {
			tableView.isEditing = false
		}
		tableView.reloadData()
	}

    func reloadHeaderView() {
        if output.selectedPlacesCount == 0 {
            tableView.isEditing = false
        }
//        tableView.reloadData()

		guard let header = tableView.headerView(forSection: CreateExcursionSettingsSections.selectedPlaces.rawValue)
				as? AddExcursionTableViewHeader
		else { return }
		header.configureLabel(distance: output.routeDistance, duration: output.routeDuration)
//		header.layoutIfNeeded()
//		var indexPathsNeedToReload = [IndexPath]()
//
//		for cell in tableView.visibleCells {
//			if let indexPath: IndexPath = tableView.indexPath(for: cell),
//			   indexPath.section == CreateExcursionSettingsSections.selectedPlaces.rawValue {
//				indexPathsNeedToReload.append(indexPath)
//			}
//		}
//
//		tableView.reloadRows(at: indexPathsNeedToReload, with: .none)
    }

	func reload(_ hasChanges: Bool) {
		output.reloadData(hasChanges)
    }

    func showAuthView() {
        let notLoginAlert = UIAlertController(title: "Вы не авторизованы! Необходимо войти в Ваш аккаунт", message: "", preferredStyle: .alert)
        notLoginAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            notLoginAlert.dismiss(animated: true, completion: nil)
        }))
        present(notLoginAlert, animated: true, completion: nil)
    }

    func showErrorView() {
        let errorAlert = UIAlertController(title: "Произошла ошибка. Повторите позже", message: "", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            errorAlert.dismiss(animated: true, completion: nil)
        }))
        present(errorAlert, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate

extension AddExcursionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = CreateExcursionSettingsSections(rawValue: indexPath.section) else { return }
        switch section {
        case .image:
            view.endEditing(true)
            didTapAddImageButton()
        case .addButton:
            view.endEditing(true)
            output.didTapAddPlaceButton()
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let section = CreateExcursionSettingsSections(rawValue: indexPath.section),
              section == .selectedPlaces,
			  isEditingTable
		else { return false }
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = CreateExcursionSettingsSections(rawValue: indexPath.section),
              section == .selectedPlaces,
			  isEditingTable,
			  editingStyle == .delete
		else { return }

		output.removePlace(at: indexPath)
	}
//	func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
//		guard let indexPath,
//			  let section = CreateExcursionSettingsSections(rawValue: indexPath.section)
////			  section == .selectedPlaces
//		else { return }
////		tableView.layoutIfNeeded()
//	}

	func tableView(_ tableView: UITableView, 
				   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
				   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		guard let section1 = CreateExcursionSettingsSections(rawValue: sourceIndexPath.section),
			  let section2 = CreateExcursionSettingsSections(rawValue: proposedDestinationIndexPath.section),
			  section1 == .selectedPlaces,
			  section2 == .selectedPlaces,
			  isEditingTable
		else { return sourceIndexPath }

		return proposedDestinationIndexPath
	}


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = CreateExcursionSettingsSections(rawValue: indexPath.section),
              section == .selectedPlaces,
			  isEditingTable
		else { return false }

        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard
            let sourceSection = CreateExcursionSettingsSections(
                rawValue: sourceIndexPath.section),
            sourceSection == .selectedPlaces,
            let destinationSection = CreateExcursionSettingsSections(
                rawValue: destinationIndexPath.section),
            destinationSection == .selectedPlaces else {
			reload(true)
            return
        }
        output.swapPlaces(from: sourceIndexPath, to: destinationIndexPath)
        reload(true)
//		tableView.reloadSections(CreateExcursionSettingsSections.selectedPlaces.rawValue, with: .fade)
//		tableView.reloadRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
    }
}

// MARK: UITableViewDataSource

extension AddExcursionViewController: UITableViewDataSource {
    // Количество секций таблицы
    func numberOfSections(in tableView: UITableView) -> Int {
        CreateExcursionSettingsSections.allCases.count
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "HeaderView") as? AddExcursionTableViewHeader,
            let section = CreateExcursionSettingsSections(rawValue: section),
            section == .selectedPlaces,
            output.selectedPlacesCount != 0
        else {
            return UIView()
        }
        header.delegate = self
        header.configure(isEditing: tableView.isEditing, distance: output.routeDistance, duration: output.routeDuration)
        return header
    }

    // Количество ячеек в каждой секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = CreateExcursionSettingsSections(rawValue: section) else { return 0 }

        switch section {
        case .image, .titleSection, .descriptionSection, .addButton:
            return 1

        case .selectedPlaces:
            return output.selectedPlacesCount
        }
    }

    // Ячейки в секции
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = CreateExcursionSettingsSections(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
        case .selectedPlaces:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExcursionConstants.TableView.SelectedPlaceCell.reuseId) as? SelectedPlaceCell else {
                return UITableViewCell()
            }
            let place = output.place(for: indexPath)
            cell.showsReorderControl = true
            cell.isUserInteractionEnabled = true
            cell.contentView.isUserInteractionEnabled = true
            cell.selectionStyle = .none
            cell.set(place: place)
            return cell
        case .addButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddExcursionConstants.TableView.AddPlaceButtonCell.reuseId) as? AddPlaceCell else {
                return UITableViewCell()
            }
            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell")
                as? ImageCell else { return UITableViewCell() }
            cell.configure(image: image)
            cell.isUserInteractionEnabled = true
            cell.contentView.isUserInteractionEnabled = true
            return cell

        case .titleSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell")
                as? TitleCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure()
            cell.contentView.isUserInteractionEnabled = false
            return cell
        case .descriptionSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddExcursionDescriptionCell")
                as? AddExcursionDescriptionCell else { return UITableViewCell() }
            cell.delegate = self
            cell.contentView.isUserInteractionEnabled = false
            cell.configure(text: excursionDescription)
            return cell
        }
    }

    // Высоты ячеек в секциях
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = CreateExcursionSettingsSections(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .image:
            return 200
        case .titleSection:
            return AddExcursionConstants.TitleField.height
        case .descriptionSection:
            return AddExcursionConstants.DescriptionField.minHeight
        case .selectedPlaces:
			return UITableView.automaticDimension
        case .addButton:
            return 50
        }
    }
}

// MARK: UITextViewDelegate

extension AddExcursionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = nil
            textView.textColor = .prog.Dynamic.text
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = AddExcursionConstants.DescriptionField.placeholder
            textView.textColor = .systemGray3
        } else {
            excursionDescription = textView.text
            textView.textColor = .prog.Dynamic.text
//            if let description = excursionDescription,
//               !description.isEmpty,
//               textView.text.isEmpty {
//                textView.text = excursionDescription
//            } else {
//                excursionDescription = textView.text
//            }
        }
    }
}

// MARK: UITextFieldDelegate

extension AddExcursionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        excursionName = textField.text
    }
}

// MARK: PHPickerViewControllerDelegate

extension AddExcursionViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        // Get the first item provider from the results
        let itemProvider = results.first?.itemProvider

        // Access the UIImage representation for the result
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.image = image
						self.reload(false)
                    }
                }
            }
        }
    }
}

// MARK: AddExcursionTableViewHeaderDelegate

extension AddExcursionViewController: AddExcursionTableViewHeaderDelegate {
    func editButtonTapped() {
		let oldValue = tableView.isEditing
		isEditingTable = !oldValue
        tableView.isEditing = !oldValue
		if oldValue {
			output.reloadData(false)
		}

    }
}
