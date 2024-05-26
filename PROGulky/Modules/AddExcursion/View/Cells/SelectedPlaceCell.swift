//
//  SelectedPlaceCell.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 09.12.2022.
//

import UIKit
import SnapKit

final class SelectedPlaceCell: UITableViewCell {
    private let sort = UILabel()
    private let title = UILabel()
    private let subtitle = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

		addSubviews(
			sort.prepareForAutoLayout(),
			title.prepareForAutoLayout(),
			subtitle.prepareForAutoLayout()
		)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not implemeted")
    }

    func set(place: Place) {
        sort.text = "\(place.sort ?? 0)"
        title.text = place.title
        subtitle.text = place.address
		layoutIfNeeded()
    }

    // MARK: configs styles

    func updateSortConstraint(isEditing: Bool) {
//        sort.snp.updateConstraints { make in
//            if isEditing {
//                make.leading.equalToSuperview()
//                    .offset(AddExcursionConstants.TableView.SelectedPlaceCell.Sort.shiftOffset)
//            } else {
//                make.leading.equalToSuperview()
//                    .offset(AddExcursionConstants.TableView.SelectedPlaceCell.Sort.marginLeft)
//            }
//        }
//        layoutIfNeeded()
    }

    private func setupUI() {
        backgroundColor = AddExcursionConstants.TableView.SelectedPlaceCell.backgroundColor
        selectionStyle = UITableViewCell.SelectionStyle.none
        configureSortLabel()
        configureTitleLabel()
        configureSubtitleLabel()
		title.setContentHuggingPriority(.defaultHigh, for: .vertical)
		subtitle.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    private func configureSortLabel() {
    }

    private func configureTitleLabel() {
        title.numberOfLines = AddExcursionConstants.TableView.SelectedPlaceCell.Title.numberOfLines
        title.font = AddExcursionConstants.TableView.SelectedPlaceCell.Title.font
    }

    private func configureSubtitleLabel() {
        subtitle.numberOfLines = AddExcursionConstants.TableView.SelectedPlaceCell.Subtitle.numberOfLines
        subtitle.font = AddExcursionConstants.TableView.SelectedPlaceCell.Subtitle.font
        subtitle.textColor = AddExcursionConstants.TableView.SelectedPlaceCell.Subtitle.textColor
    }

    // MARK: constraints

    private func setupConstraints() {
//        setSortLabelConstraint()
//        setTitleLabelConstraints()
//        setSubtitleLabelConstraint()

		sort.widthAnchor ~= AddExcursionConstants.TableView.SelectedPlaceCell.Sort.width
		sort.centerYAnchor ~= centerYAnchor
		sort.leadingAnchor ~= leadingAnchor + AddExcursionConstants.TableView.SelectedPlaceCell.Sort.marginLeft

		title.topAnchor ~= topAnchor + AddExcursionConstants.TableView.SelectedPlaceCell.Title.YOffset
		title.leadingAnchor ~= sort.trailingAnchor + AddExcursionConstants.TableView.SelectedPlaceCell.Title.marginLeft
		title.trailingAnchor ~= trailingAnchor - AddExcursionConstants.TableView.SelectedPlaceCell.Title.trailing

		subtitle.leadingAnchor ~= title.leadingAnchor
		subtitle.trailingAnchor ~= title.trailingAnchor
		subtitle.topAnchor ~= title.bottomAnchor + AddExcursionConstants.TableView.SelectedPlaceCell.Subtitle.marginTop
		subtitle.bottomAnchor ~= bottomAnchor - 8


    }

    private func setSortLabelConstraint() {

//        sort.snp.makeConstraints { make in
//            make.width.equalTo(AddExcursionConstants.TableView.SelectedPlaceCell.Sort.width)
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview()
//                .offset(AddExcursionConstants.TableView.SelectedPlaceCell.Sort.marginLeft)
//        }
//        sort.translatesAutoresizingMaskIntoConstraints = false
//        sort.widthAnchor.constraint(equalToConstant: AddExcursionConstants.TableView.SelectedPlaceCell.Sort.width).isActive = true
//        sort.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        sort.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AddExcursionConstants.TableView.SelectedPlaceCell.Sort.marginLeft).isActive = true
    }

    private func setTitleLabelConstraints() {

//        title.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//                .offset(AddExcursionConstants.TableView.SelectedPlaceCell.Title.YOffset)
//            make.leading.equalTo(self.sort.snp.trailing)
//                .offset(AddExcursionConstants.TableView.SelectedPlaceCell.Title.marginLeft)
//            make.trailing.equalToSuperview()
//                .offset(-AddExcursionConstants.TableView.SelectedPlaceCell.Title.trailing)
//        }

//        title.translatesAutoresizingMaskIntoConstraints = false
//        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: AddExcursionConstants.TableView.SelectedPlaceCell.Title.YOffset).isActive = true
//        title.leadingAnchor.constraint(equalTo: sort.trailingAnchor, constant: AddExcursionConstants.TableView.SelectedPlaceCell.Title.marginLeft).isActive = true
//        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AddExcursionConstants.Screen.padding).isActive = true
    }

    private func setSubtitleLabelConstraint() {

//        subtitle.snp.makeConstraints { make in
//            make.leading.equalTo(self.sort.snp.trailing)
//                .offset(AddExcursionConstants.TableView.SelectedPlaceCell.Title.marginLeft)
//            make.trailing.equalToSuperview()
//                .offset(-AddExcursionConstants.TableView.SelectedPlaceCell.Title.trailing)
//            make.top.equalTo(self.title.snp.bottom)
//                .offset(AddExcursionConstants.TableView.SelectedPlaceCell.Subtitle.marginTop)
//        }

//        subtitle.translatesAutoresizingMaskIntoConstraints = false
//        subtitle.leadingAnchor.constraint(equalTo: sort.trailingAnchor, constant: AddExcursionConstants.TableView.SelectedPlaceCell.Subtitle.marginLeft).isActive = true
//        subtitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AddExcursionConstants.Screen.padding).isActive = true
//        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: AddExcursionConstants.TableView.SelectedPlaceCell.Subtitle.marginTop).isActive = true
    }
}
