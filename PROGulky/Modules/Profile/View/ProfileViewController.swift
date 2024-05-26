//
//  ProfileViewController.swift
//  PROGulky
//
//  Created by SemyonPyatkov on 31/10/2022.
//

import UIKit
import SnapKit
import MessageUI
import PhotosUI

private let reuseIdentifier = "SettingsCell"
private let imagePicker = UIImagePickerController()

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
    var output: ProfileViewOutput!
    private let userInfoHeader = UserInfoHeader(frame: .zero)
    private var tableView = UITableView()
    private let deleteBtn = UIButton()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .prog.Dynamic.background
        configureTableView()
        configureUI()
        userInfoHeader.configure(output.headerDisplayData)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfoHeader.configure(output.headerDisplayData)
    }

    private func configureUI() {
        navigationItem.title = TextConstantsProfile.titleProfile
        view.addSubview(userInfoHeader)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userInfoHeader.profileImageView.isUserInteractionEnabled = true
        userInfoHeader.profileImageView.addGestureRecognizer(tapGestureRecognizer)

        userInfoHeader.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                .offset(ProfileViewConstants.Header.topOffset)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(ProfileViewConstants.Header.height)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.userInfoHeader.snp.bottom)
                .offset(ProfileViewConstants.TableView.topOffset)
            make.leading.equalToSuperview()
                .offset(ProfileViewConstants.TableView.offset)
            make.trailing.equalToSuperview()
                .inset(ProfileViewConstants.TableView.offset)
            make.height.equalTo(ProfileViewConstants.TableView.height)
        }

        deleteBtn.backgroundColor = .prog.Dynamic.background
        deleteBtn.setTitle(TextConstantsProfile.deleteAccount, for: .normal)
        deleteBtn.setTitleColor(.red, for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: ProfileViewConstants.DeleteBtn.fontSize)
        deleteBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        view.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom)
            make.leading.equalToSuperview()
                .offset(ProfileViewConstants.DeleteBtn.offset)
            make.trailing.equalToSuperview()
                .inset(ProfileViewConstants.DeleteBtn.offset)
            make.height.equalTo(ProfileViewConstants.DeleteBtn.heightBtn)
        }
    }

    private func configureTableView() {
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = ProfileViewConstants.TableView.rowHeight
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .prog.Dynamic.background
        tableView.separatorStyle = .singleLine
        tableView.contentInset.top = ProfileViewConstants.TableView.contentInsetTop
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false

        tableView.subviews.forEach { view in
            view.layer.masksToBounds = false
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = ProfileViewConstants.Shadow.shadowRadius
            view.layer.shadowOpacity = ProfileViewConstants.Shadow.shadowOpacity
            view.layer.shadowColor = ProfileViewConstants.Shadow.shadowColor.cgColor
        }
    }

    private func setupTableViewHeader(section: Int) -> UIView {
        let view = UIView()
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = .prog.Dynamic.lightText
//        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
                .offset(ProfileViewConstants.TableView.leftAnchor)
        }
        return view
    }

    // MARK: Здесь делаю аву пользователя

    @objc func imageTapped() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc func buttonAction(sender: UIButton!) {
        let alert = UIAlertController(title: "Вы уверены, что хотите удалить аккаунт?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { _ in
            self.deleteAccount()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func showErrorView() {
        let errorAlert = UIAlertController(title: "Произошла ошибка. Повторите позже", message: "", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            errorAlert.dismiss(animated: true, completion: nil)
        }))
        present(errorAlert, animated: true, completion: nil)
    }
}

// MARK: ProfileViewInput

extension ProfileViewController: ProfileViewInput {
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        SettingsSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }

        switch section {
        case .Account:
			if UserDefaultsManager.shared.isGuide {
				return AccountOptions.allCases.count - 1
			} else {
				return AccountOptions.allCases.count
			}
        case .Other:
            return OtherOptions.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        setupTableViewHeader(section: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        ProfileViewConstants.TableView.heightForHeader
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ProfileViewConstants.TableView.Cell.height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SettingsCell
        cell?.selectionStyle = .none
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
        case .Account:
            let account = AccountOptions(rawValue: indexPath.row)
            cell?.sectionType = account
        case .Other:
            let other = OtherOptions(rawValue: indexPath.row)
            cell?.sectionType = other
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }

        switch section {
        case .Account:
            switch AccountOptions(rawValue: indexPath.row) {
//            case 0:
//                present(PlugViewController(), animated: true) // Заглушка
//                print(TextConstantsProfile.titlePersonalData)
//            case 1:
//                present(PlugViewController(), animated: true) // Заглушка
//                print(TextConstantsProfile.titleAchievements)
//            case 2:
//                present(PlugViewController(), animated: true) // Заглушка
//                print(TextConstantsProfile.titleHistory)
			case .beGuide:
                showMailComposer(message: TextConstantsProfile.beGuideMessage)
			case .changeTheme:
                if UserDefaults.standard.bool(forKey: UserKeys.isDarkMode.rawValue) == true {
                    UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
                    UserDefaults.standard.set(false, forKey: UserKeys.isDarkMode.rawValue)
                } else {
                    UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
                    UserDefaults.standard.set(true, forKey: UserKeys.isDarkMode.rawValue)
                }
                UserDefaults.standard.synchronize()
                print(TextConstantsProfile.changeTheme)
            default:
                print("no action")
            }
        case .Other:
            switch OtherOptions(rawValue: indexPath.row) {
			case .contactUs:
                showMailComposer(message: TextConstantsProfile.contactUsMessageTitle)
//			case .:
//                if let url = URL(string: "https://pages.flycricket.io/progulki/privacy.html") {
//                    UIApplication.shared.open(url)
//                }
			case .signOut:
                let alert = UIAlertController(title: "Вы уверены, что хотите выйти?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Продолжить", style: .default, handler: { _ in
                    self.goToLogin()
                }))
                alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)

            default:
                print("no action")
            }
        }
    }

    func goToLogin() {
        output.logoutButtonTapped()
    }

    func deleteAccount() {
        output.deleteAccountButtonTapped()
    }

    func showMailComposer(message: String) {
        guard MFMailComposeViewController.canSendMail() else {
            print("can't send")
            return
        }

        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([TextConstantsProfile.contactUsMail])
        composer.setSubject(message)

        present(composer, animated: true)
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            break
        }

        controller.dismiss(animated: true)
    }
}

extension ProfileViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.subviews.forEach { view in
            view.layer.shadowColor = ProfileViewConstants.Shadow.shadowColor.cgColor
        }
    }
}

// MARK: PHPickerViewControllerDelegate

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        // Get the first item provider from the results
        let itemProvider = results.first?.itemProvider

        // Access the UIImage representation for the result
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.userInfoHeader.profileImageView.image = image
                        self.output.saveUserAvatar(image: image)
//                        self.reload()
                    }
                }
            }
        }
    }
}
