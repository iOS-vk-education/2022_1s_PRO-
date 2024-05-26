//
//  CustomTextField.swift
//  PROGulky
//
//  Created by Сергей Киселев on 23.11.2022.
//

import UIKit

// MARK: - CustomTextField

final class CustomTextField: UITextField {
    private var security = Bool()
    private var name = String()

    convenience init(name: String, security: Bool) {
        self.init()
        self.name = name
        self.security = security
        entryField()
    }

    private func entryField() {
        textColor = .prog.Dynamic.text
        placeholder = name
        layer.masksToBounds = false
        layer.shadowRadius = 9
        layer.shadowColor = UIColor.prog.Dynamic.shadow.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.cornerRadius = 14
        autocorrectionType = .no
        clearButtonMode = .always
        isSecureTextEntry = security
        autocapitalizationType = .none
		font = UIFont.systemFont(ofSize: 16, weight: .medium)
        backgroundColor = .prog.Dynamic.background
        layer.borderColor = UIColor.lightGray.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: frame.height))
        leftViewMode = .always
    }
}

extension CustomTextField {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = UIColor.prog.Dynamic.shadow.cgColor
    }
}
