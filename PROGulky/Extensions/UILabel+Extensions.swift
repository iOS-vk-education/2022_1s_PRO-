//
//  UILabel+Extensions.swift
//  PROGulky
//
//  Created by Semyon Pyatkov on 08.11.2022.
//

import UIKit

// MARK: - VerticalAlignedLabel

final class VerticalAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }

        super.drawText(in: newRect)
    }
}
