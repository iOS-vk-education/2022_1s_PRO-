//
//  ExcursionCell.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 06.11.2022.
//

import UIKit
import Kingfisher
// MARK: - ExcursionCell

final class ExcursionCell: UITableViewCell {
    private let excursionImageView = UIImageView()
    private let excursionTitleLabel = VerticalAlignedLabel()
    private let excursionRatingImage = UIImageView()
    private let excursionRatingLabel = UILabel()
    private var excursionParametersLabel = UILabel()

    private let excursionOwnerNameLabel = UILabel() // Имя вендора
    private let excursionOwnerImage = UIImageView() // Аватар вендора

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubviews(excursionImageView,
                                excursionTitleLabel,
                                excursionRatingImage,
                                excursionRatingLabel,
                                excursionParametersLabel,
                                excursionOwnerNameLabel,
                                excursionOwnerImage)

        setupUI()
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.shadowColor = ExcursionsListConstants.ExcursionCell.shadowColor.cgColor
        contentView.layer.shadowOpacity = ExcursionsListConstants.ExcursionCell.shadowOpacity
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = ExcursionsListConstants.ExcursionCell.shadowRadius

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: ExcursionsListConstants.ExcursionCell.ContentView.marginTop,
            left: ExcursionsListConstants.Screen.padding,
            bottom: ExcursionsListConstants.ExcursionCell.ContentView.marginBottom,
            right: ExcursionsListConstants.Screen.padding
        ))
        contentView.layer.cornerRadius = ExcursionsListConstants.ExcursionCell.cornerRadius
        contentView.backgroundColor = .prog.Dynamic.lightBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not implemeted")
    }

    func set(excursion: ExcursionViewModel) {
        setupImage(with: excursion.image)
        setupOwnerImage(with: excursion.ownerImage)

        excursionTitleLabel.text = excursion.title
        excursionRatingImage.image = UIImage(systemName: ExcursionsListConstants.ExcursionCell.RatingImage.name)?
            .withTintColor(ExcursionsListConstants.ExcursionCell.RatingImage.color, renderingMode: .alwaysOriginal)
        excursionRatingLabel.text = String(excursion.rating)
        excursionParametersLabel.text = String(excursion.parameters)
        excursionOwnerNameLabel.text = String(excursion.owner)
    }

    private func setupImage(with image: String?) {
		let placeholder = UIImage(systemName: "photo")?.withTintColor(.gray, renderingMode: .alwaysTemplate)
//        if let image = image {
		let imageURL = "\(ExcursionsListConstants.Api.imageURL)/\(image ?? "")"
		excursionImageView.kf.setImage(with: URL(string: imageURL), placeholder: placeholder)
//        } else {
//			excursionImageView.image = placeholder
//        }
    }

    private func setupOwnerImage(with image: String?) {
        if let image = image {
            let imageURL = "\(ExcursionsListConstants.Api.ownerImageURL)/\(image)"
			excursionOwnerImage.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(systemName: "person.fill"))
        } else {
            excursionOwnerImage.image = UIImage(systemName: "person.fill")
        }
    }

    // MARK: configs styles

    private func setupUI() {
        backgroundColor = ExcursionsListConstants.Screen.backgroundColor

        configureCell()
        configureImageView()
        configureTitleLabel()
        configurRatingImage()
        configureRatingLabel()
        configureParametersLabel()
        configureOwnerLabel()
        configureOwnerImage()
    }

    private func configureCell() {
        selectionStyle = UITableViewCell.SelectionStyle.none
    }

    private func configureImageView() {
        excursionImageView.layer.cornerRadius = ExcursionsListConstants.ExcursionCell.Image.cornerRadius
        excursionImageView.clipsToBounds = true
        excursionImageView.contentMode = .scaleAspectFill
    }

    private func configureTitleLabel() {
        excursionTitleLabel.numberOfLines = 2
        excursionTitleLabel.contentMode = .bottom
        excursionTitleLabel.textAlignment = .right
//        excursionTitleLabel.adjustsFontSizeToFitWidth = true
        excursionTitleLabel.font = UIFont.systemFont(ofSize: ExcursionsListConstants.ExcursionCell.Title.fontSize,
                                                     weight: ExcursionsListConstants.ExcursionCell.Title.fontWeight)
    }

    private func configurRatingImage() {
        excursionRatingImage.clipsToBounds = true
    }

    private func configureRatingLabel() {
        excursionRatingLabel.font = UIFont.systemFont(ofSize: ExcursionsListConstants.ExcursionCell.RatingLabel.fontSize,
                                                      weight: ExcursionsListConstants.ExcursionCell.RatingLabel.fontWeight)
        excursionRatingLabel.textColor = ExcursionsListConstants.ExcursionCell.RatingLabel.textColor
        excursionRatingLabel.textAlignment = .right
    }

    private func configureParametersLabel() {
        excursionParametersLabel.font = UIFont.systemFont(ofSize: ExcursionsListConstants.ExcursionCell.Parameters.fontSize,
                                                          weight: ExcursionsListConstants.ExcursionCell.Parameters.fontWeight)
        excursionParametersLabel.textAlignment = .right
        excursionParametersLabel.textColor = ExcursionsListConstants.ExcursionCell.Parameters.textColor
    }

    private func configureOwnerLabel() {
        excursionOwnerNameLabel.numberOfLines = 1
        excursionOwnerNameLabel.font = UIFont.systemFont(ofSize: ExcursionsListConstants.ExcursionCell.OwnerLabel.fontSize,
                                                         weight: ExcursionsListConstants.ExcursionCell.OwnerLabel.fontWeight)
        excursionOwnerNameLabel.textColor = ExcursionsListConstants.ExcursionCell.OwnerLabel.textColor
        excursionOwnerNameLabel.textAlignment = .right
    }

    private func configureOwnerImage() {
        excursionOwnerImage.layer.masksToBounds = false
        excursionOwnerImage.layer.cornerRadius = ExcursionsListConstants.ExcursionCell.OwnerImage.cornerRadius
        excursionOwnerImage.clipsToBounds = true
    }

    // MARK: constraints

    private func setupConstraints() {
        setImageConstraints()
        setRatingLabelConstraint()
        setRatingImageConstraints()
        setTitleLabelConstraints()
        setParametersLabelConstraint()
        setVendorNameLabelConstraint()
        setVendorImageConstraint()
    }

    private func setImageConstraints() {
        excursionImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(ExcursionsListConstants.Screen.padding)
            make.height.equalTo(ExcursionsListConstants.ExcursionCell.Image.height)
            make.width.equalTo(excursionImageView.snp.height).multipliedBy(ExcursionsListConstants.ExcursionCell.Image.aspectRatio)
        }
    }

    private func setRatingImageConstraints() {
        excursionRatingImage.snp.makeConstraints { make in
            make.right.equalTo(excursionRatingLabel.snp.left)
            make.top.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.RatingLabel.inset + ExcursionsListConstants.ExcursionCell.RatingImage.offset)
            make.height.equalTo(ExcursionsListConstants.ExcursionCell.RatingImage.height)
            make.width.equalTo(excursionRatingLabel.snp.height).multipliedBy(ExcursionsListConstants.ExcursionCell.RatingImage.aspectRatio)
        }
    }

    private func setRatingLabelConstraint() {
        excursionRatingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.RatingLabel.inset)
            make.right.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.contentIndent)
        }
    }

    private func setTitleLabelConstraints() {
        excursionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(excursionRatingLabel.snp.bottom).offset(ExcursionsListConstants.ExcursionCell.Title.offset)
            make.right.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.contentIndent)
            make.left.equalTo(excursionImageView.snp.right).offset(ExcursionsListConstants.ExcursionCell.contentIndent)
        }
    }

    private func setParametersLabelConstraint() {
        excursionParametersLabel.snp.makeConstraints { make in
            make.top.equalTo(excursionTitleLabel.snp.bottom).offset(ExcursionsListConstants.ExcursionCell.Parameters.offset)
            make.right.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.contentIndent)
            make.left.equalTo(excursionImageView.snp.right).offset(ExcursionsListConstants.ExcursionCell.contentIndent)
        }
    }

    private func setVendorImageConstraint() {
        excursionOwnerImage.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.OwnerImage.bottomInset)
            make.height.equalTo(ExcursionsListConstants.ExcursionCell.OwnerImage.height)
            make.width.equalTo(ExcursionsListConstants.ExcursionCell.OwnerImage.width)
            make.right.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.contentIndent)
        }
    }

    private func setVendorNameLabelConstraint() {
        excursionOwnerNameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.OwnerLabel.bottomInset)
            make.right.equalToSuperview().inset(ExcursionsListConstants.ExcursionCell.contentIndent + 25)
            make.left.equalTo(excursionImageView.snp.right).offset(ExcursionsListConstants.ExcursionCell.contentIndent)
        }
    }
}

extension ExcursionCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        contentView.layer.shadowColor = ExcursionsListConstants.ExcursionCell.shadowColor.cgColor
    }
}
