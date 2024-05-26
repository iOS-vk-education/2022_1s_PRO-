//
//  AddExcursionDescriptionCell.swift
//  PROGulky
//
//  Created by Иван Тазенков on 26.12.2022.
//

import Foundation
import UIKit

typealias AddExcursionDescriptionCellDelegate = UITextViewDelegate

// MARK: - AddExcursionDescriptionCell

final class AddExcursionDescriptionCell: UITableViewCell {
    private let descriptionField = UITextView(frame: .zero)
    var delegate: AddExcursionDescriptionCellDelegate?

    func configure(text: String?) {
        if let text = text {
            descriptionField.text = text
            descriptionField.textColor = .prog.Dynamic.text
        } else {
            descriptionField.text = AddExcursionConstants.DescriptionField.placeholder
            descriptionField.textColor = .systemGray3
        }
        addSubview(descriptionField)
        descriptionField.delegate = delegate
        setupConstraints()

        descriptionField.layer.masksToBounds = true
        descriptionField.layer.cornerRadius = AddExcursionConstants.DescriptionField.cornerRadius
        descriptionField.font = UIFont.systemFont(ofSize: 15)
        descriptionField.addDoneButtonOnKeyboard()
		descriptionField.backgroundColor = .systemGray6
    }

    func setupConstraints() {
        descriptionField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
