//
//  titleCell.swift
//  PROGulky
//
//  Created by Иван Тазенков on 26.12.2022.
//

import Foundation
import UIKit

typealias TitleCellDelegate = UITextFieldDelegate

// MARK: - TitleCell

final class TitleCell: UITableViewCell {
    private let titleField = UITextField(frame: .zero)
    var delegate: TitleCellDelegate?

    func configure() {
        addSubview(titleField)
        titleField.delegate = delegate
        setupConstraints()
        titleField.layer.masksToBounds = true // Убирает дефолтную рамку
        titleField.borderStyle = UITextField.BorderStyle.roundedRect
        titleField.placeholder = AddExcursionConstants.TitleField.placeholder
//        titleField.layer.cornerRadius = AddExcursionConstants.TitleField.cornerRadius
        titleField.returnKeyType = .done
        titleField.addDoneButtonOnKeyboard()
		titleField.backgroundColor = .systemGray6
    }

    func setupConstraints() {
        titleField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
