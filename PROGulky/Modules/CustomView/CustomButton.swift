//
//  CustomButton.swift
//  PROGulky
//
//  Created by Сергей Киселев on 23.11.2022.
//

import UIKit

// MARK: - CustomButton

final class CustomButton: UIButton {
    init(title: String,
         color: UIColor,
         textColor: UIColor,
         shadow: Bool = false) {
        super.init(frame: .zero)

        layer.cornerRadius = 20
        var config = UIButton.Configuration.filled()
        config.title = title
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.baseBackgroundColor = color
        config.baseForegroundColor = textColor
        config.background.cornerRadius = 16
        config.cornerStyle = .fixed

        if shadow {
            layer.shadowRadius = 9
            layer.shadowColor = UIColor.prog.Dynamic.shadow.cgColor
            layer.shadowOffset = .zero
            layer.shadowOpacity = 0.4
        }

        configuration = config
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomButton {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = UIColor.prog.Dynamic.shadow.cgColor
    }
}
