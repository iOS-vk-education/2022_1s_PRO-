//
//  AddCell.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 09.12.2022.
//

import UIKit

final class AddPlaceCell: UITableViewCell {
    private let title = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews(title)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not implemeted")
    }

    // MARK: configs styles

    private func setupUI() {
        backgroundColor = AddExcursionConstants.TableView.AddPlaceButtonCell.backgroundColor
        selectionStyle = UITableViewCell.SelectionStyle.none
        configureTitleLabel()
    }

    private func configureTitleLabel() {
        title.font = AddExcursionConstants.TableView.AddPlaceButtonCell.Title.font
        title.text = AddExcursionConstants.TableView.AddPlaceButtonCell.Title.text
        backgroundColor = .prog.Dynamic.primary
        title.textColor = .white
    }

    // MARK: constraints

    private func setupConstraints() {
        setTitleLabelConstraints()
    }

    private func setTitleLabelConstraints() {
        title.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
