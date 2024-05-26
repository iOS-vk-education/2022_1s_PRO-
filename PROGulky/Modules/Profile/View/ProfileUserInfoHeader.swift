//
//  ProfileUserInfoHeader.swift
//  PROGulky
//
//  Created by Сергей Киселев on 23.10.2022.
//

import UIKit
import Kingfisher
// MARK: - UserInfoHeader

final class UserInfoHeader: UIView {
    struct DisplayData {
        let username: String
        let status: String
		let image: String?
    }

    private let imagePicker = UIImagePickerController()
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true

        iv.layer.shadowOpacity = ProfileViewConstants.Header.shadowOpacity
        iv.layer.shadowRadius = ProfileViewConstants.Header.cornerRadius
        iv.layer.cornerRadius = ProfileViewConstants.Header.cornerRadius
        iv.layer.shadowColor = ProfileViewConstants.Header.shadowColor.cgColor

        guard let image = UserDefaults.standard.string(forKey: UserKeys.image.rawValue) else {
            iv.image = UIImage(
                systemName: "person.crop.circle")?.withTintColor(.prog.Dynamic.primary, renderingMode: .alwaysOriginal)
            return iv
        }

        let imageURL = "\(ExcursionsListConstants.Api.ownerImageURL)/\(image)"
		iv.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(systemName: "person.crop.circle"))

        return iv
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: UserKeys.name.rawValue)
        label.textColor = .prog.Dynamic.primary
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = TextConstantsProfile.titleUserStatus + " - " + (UserDefaults.standard.string(forKey: UserKeys.role.rawValue) ?? "")
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .prog.Dynamic.text
        return label
    }()

    private enum Constants {
        static let offset: CGFloat = 10
        static let imagesSize: CGFloat = 80
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(profileImageView,
                    usernameLabel,
                    statusLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.imagesSize)
            make.height.equalTo(Constants.imagesSize)
        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.profileImageView.snp.bottom).offset(Constants.offset)
            make.centerX.equalToSuperview()
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(Constants.offset)
            make.centerX.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ displayData: DisplayData) {
        usernameLabel.text = displayData.username
        statusLabel.text = displayData.status
		guard let imageString = displayData.image,
			  let url = URL(string: "\(ExcursionsListConstants.Api.ownerImageURL)/\(imageString)")
		else { 
			profileImageView.image = UIImage(systemName: "person.crop.circle")
			return }
		profileImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle"))
    }
}

extension UserInfoHeader {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        profileImageView.layer.shadowColor = ProfileViewConstants.Header.shadowColor.cgColor
        layer.shadowColor = UIColor.prog.Dynamic.shadow.cgColor
    }
}
