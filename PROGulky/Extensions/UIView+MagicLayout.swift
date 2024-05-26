//
//  UIView+MagicLayout.swift
//  PROGulky
//
//  Created by Тазенков Иван on 25.05.2024.
//

import UIKit
public extension UIView {
	@discardableResult
	func prepareForAutoLayout() -> Self {
		translatesAutoresizingMaskIntoConstraints = false
		return self
	}

	func pinEdgesToSuperviewEdges(withOffset offset: CGFloat) {
		pinEdgesToSuperviewEdges(
			top: offset,
			left: offset,
			bottom: offset,
			right: offset
		)
	}

	func pinEdgesToSuperviewEdges(
		top: CGFloat = 0,
		left: CGFloat = 0,
		bottom: CGFloat = 0,
		right: CGFloat = 0
	) {
		guard let superview = superview else {
			fatalError("There is no superview")
		}
		leadingAnchor ~= superview.leadingAnchor + left
		trailingAnchor ~= superview.trailingAnchor - right
		topAnchor ~= superview.topAnchor + top
		bottomAnchor ~= superview.bottomAnchor - bottom
	}

	func pinToCenterSuperview(xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
		guard let superview = superview else {
			fatalError("There is no superview")
		}
		centerXAnchor ~= superview.centerXAnchor + xOffset
		centerYAnchor ~= superview.centerYAnchor + yOffset
	}

	func pinToCenterXSuperview(xOffset: CGFloat = 0) {
		guard let superview = superview else {
			fatalError("There is no superview")
		}
		centerXAnchor ~= superview.centerXAnchor + xOffset
	}

	func pinToCenterYSuperview(yOffset: CGFloat = 0) {
		guard let superview = superview else {
			fatalError("There is no superview")
		}
		centerYAnchor ~= superview.centerYAnchor + yOffset
	}

	enum PinnedSide {
		case top
		case left
		case right
		case bottom
	}

	func pinEdgesToSuperviewEdges(excluding side: PinnedSide) {
		switch side {
		case .top:
			pinToSuperview([.left, .right, .bottom])
		case .left:
			pinToSuperview([.top, .right, .bottom])
		case .right:
			pinToSuperview([.top, .left, .bottom])
		case .bottom:
			pinToSuperview([.top, .left, .right])
		}
	}

	func pinToSuperview(_ sides: [PinnedSide]) {
		guard let superview = superview, !sides.isEmpty else {
			fatalError("There is no superview or sides")
		}
		sides.forEach { side in
			switch side {
			case .top:
				topAnchor ~= superview.topAnchor
			case .right:
				trailingAnchor ~= superview.trailingAnchor
			case .left:
				leadingAnchor ~= superview.leadingAnchor
			case .bottom:
				bottomAnchor ~= superview.bottomAnchor
			}
		}
	}

	func pin(
		to view: UIView,
		top: CGFloat = 0,
		left: CGFloat = 0,
		bottom: CGFloat = 0,
		right: CGFloat = 0
	) {
		pin(to: view, edgesInsets: UIEdgeInsets(
			top: top,
			left: left,
			bottom: bottom,
			right: right
		))
	}

	func pin(to view: UIView, edgesInsets: UIEdgeInsets) {
		if view.translatesAutoresizingMaskIntoConstraints != false &&
			translatesAutoresizingMaskIntoConstraints != false {
			fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
		}
		topAnchor ~= view.topAnchor + edgesInsets.top
		trailingAnchor ~= view.trailingAnchor - edgesInsets.right
		leadingAnchor ~= view.leadingAnchor + edgesInsets.left
		bottomAnchor ~= view.bottomAnchor - edgesInsets.bottom
	}

	func pin(as view: UIView, using sides: [PinnedSide]) {
		if view.translatesAutoresizingMaskIntoConstraints != false &&
			translatesAutoresizingMaskIntoConstraints != false {
			fatalError("Pin to the view with translatesAutoresizingMaskIntoConstraints = true")
		}
		sides.forEach { side in
			switch side {
			case .top:
				topAnchor ~= view.topAnchor
			case .right:
				trailingAnchor ~= view.trailingAnchor
			case .left:
				leadingAnchor ~= view.leadingAnchor
			case .bottom:
				bottomAnchor ~= view.bottomAnchor
			}
		}
	}

	func equalSides(size: CGFloat) {
		heightAnchor ~= size
		widthAnchor ~= size
	}
}

public struct ConstraintAttribute<T: AnyObject> {
	let anchor: NSLayoutAnchor<T>
	let const: CGFloat
}

public struct LayoutGuideAttribute {
	let guide: UILayoutSupport
	let const: CGFloat
}

public struct MultiplierAttribute {
	let anchor: NSLayoutDimension
	let multiplier: CGFloat
}

public func + <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
	return ConstraintAttribute(anchor: lhs, const: rhs)
}

public func + (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
	return LayoutGuideAttribute(guide: lhs, const: rhs)
}

public func - <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
	return ConstraintAttribute(anchor: lhs, const: -rhs)
}

public func - (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
	return LayoutGuideAttribute(guide: lhs, const: -rhs)
}

public func * (lhs: NSLayoutDimension, rhs: CGFloat) -> MultiplierAttribute {
	return MultiplierAttribute(anchor: lhs, multiplier: rhs)
}

// ~= is used instead of == because Swift can't overload == for NSObject subclass
@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: UILayoutSupport) -> NSLayoutConstraint {
	let constraint = lhs.constraint(equalTo: rhs.bottomAnchor)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
	let constraint = lhs.constraint(equalTo: rhs)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
	let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
	let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
	let constraint = lhs.constraint(equalTo: rhs.anchor, constant: rhs.const)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: LayoutGuideAttribute) -> NSLayoutConstraint {
	let constraint = lhs.constraint(equalTo: rhs.guide.bottomAnchor, constant: rhs.const)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
	let constraint = lhs.constraint(equalToConstant: rhs)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutDimension, rhs: MultiplierAttribute) -> NSLayoutConstraint {
	let constraint = lhs.constraint(equalTo: rhs.anchor, multiplier: rhs.multiplier)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
	let constraint = lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.const)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func <= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
	let constraint = lhs.constraint(lessThanOrEqualToConstant: rhs)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
	let constraint = lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.const)
	constraint.isActive = true
	return constraint
}

@discardableResult
public func >= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
	let constraint = lhs.constraint(greaterThanOrEqualToConstant: rhs)
	constraint.isActive = true
	return constraint
}


public extension NSAttributedString {
	/// Считает высоту строки заданной ширины
	/// - Parameter containerWidth: ширина контейнера
	/// - Returns: высота контейнера
	func height(containerWidth: CGFloat) -> CGFloat {
		let size = CGSize(
			width: containerWidth,
			height: CGFloat.greatestFiniteMagnitude
		)

		return rectFor(size: size).integral.size.height
	}

	/// Считает ширину строки заданной высоты
	/// - Parameter containerHeight: высота контейнера
	/// - Returns: ширина контейнера
	func width(containerHeight: CGFloat) -> CGFloat {
		let size = CGSize(
			width: CGFloat.greatestFiniteMagnitude,
			height: containerHeight
		)

		return rectFor(size: size).integral.size.width
	}

	private func rectFor(size: CGSize) -> CGRect {
		let textStorage = NSTextStorage(attributedString: self)

		let textContainer = NSTextContainer(size: size)
		textContainer.lineFragmentPadding = 0.0

		let layoutManager = NSLayoutManager()
		layoutManager.addTextContainer(textContainer)

		textStorage.addLayoutManager(layoutManager)
		layoutManager.glyphRange(
			forBoundingRect: CGRect(
				origin: .zero,
				size: size
			),
			in: textContainer
		)

		return layoutManager.usedRect(for: textContainer)
	}
}


public extension String {
	/// Билдер из String
	var stringBuilder: AttributedStringBuilder {
		return AttributedStringBuilder(string: self)
	}
}

public extension NSAttributedString {
	/// Билдер из NSAttributedString
	var stringBuilder: AttributedStringBuilder {
		return AttributedStringBuilder(attributedString: self)
	}
}

/// Билдер Attributed строки
public final class AttributedStringBuilder {
	/// аttributes  строки
	public typealias Attributes = [NSAttributedString.Key: Any]

	private var attributedString = NSMutableAttributedString(string: "")
	private var paragraphStyle = NSMutableParagraphStyle()

	private var attributedStringRange: NSRange {
		return NSRange(location: 0, length: attributedString.length)
	}

	/// Инициализатор из String
	/// - Parameter string: строка
	public init(string: String) {
		self.attributedString = NSMutableAttributedString(string: string)
	}

	/// Инициализатор из NSAttributedString
	/// - Parameter attributedString: Attributed строка
	public init(attributedString: NSAttributedString) {
		self.attributedString = NSMutableAttributedString(attributedString: attributedString)
	}

	/// Добавляет межбуквенное расстояние к текущей строке
	/// - Parameter letterSpacing: межбуквенное растояние
	@discardableResult
	public func setLetterSpacing(_ letterSpacing: CGFloat) -> AttributedStringBuilder {
		attributedString.addAttribute(.kern, value: letterSpacing, range: attributedStringRange)
		return self
	}

	/// Добавляет attribute для смещения base line строки
	/// - Parameter offset: оффсет на который смещается
	@discardableResult
	public func setBaselineOffset(_ offset: CGFloat) -> AttributedStringBuilder {
		attributedString.addAttribute(.baselineOffset, value: offset, range: attributedStringRange)
		return self
	}

	/// Добавляет аttribute цвета текста для всей строки
	/// - Parameter color: цвет
	@discardableResult
	public func setTextColor(_ color: UIColor) -> AttributedStringBuilder {
		attributedString.addAttribute(.foregroundColor, value: color, range: attributedStringRange)
		return self
	}

	/// Добавляет аttribute шрифт для всей строки
	/// - Parameter font: шрифт
	@discardableResult
	public func setFont(_ font: UIFont) -> AttributedStringBuilder {
		attributedString.addAttribute(.font, value: font, range: attributedStringRange)
		return self
	}

	/// Добавляет аttribute шрифт для заданного промежутка
	/// - Parameters:
	///   - font: шрифт
	///   - range: промежуток
	@discardableResult
	public func setFontPart(_ font: UIFont, range: NSRange) -> AttributedStringBuilder {
		attributedString.addAttribute(.font, value: font, range: range)
		return self
	}

	/// Добавляет аttribute ccылки для заданного промежутка
	/// - Parameters:
	///   - link: шрифт
	///   - range: промежуток
	@discardableResult
	public func setLink(_ link: String, range: NSRange) -> AttributedStringBuilder {
		attributedString.addAttributes([.link: link], range: range)
		return self
	}

	/// Добавляет аttribute цвета текста для заданного промежутка
	/// - Parameters:
	///   - color: цвет
	///   - range: промежуток
	@discardableResult
	public func setColorPart(_ color: UIColor, range: NSRange) -> AttributedStringBuilder {
		attributedString.addAttribute(.foregroundColor, value: color, range: range)
		return self
	}

	/// Добавляет аttribute межстрочного расстояния для всей строки
	/// - Parameter lineSpacing: межстрочное растояние
	@discardableResult
	public func setLineSpacing(_ lineSpacing: CGFloat) -> AttributedStringBuilder {
		paragraphStyle.lineSpacing = lineSpacing
		attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: attributedStringRange)
		return self
	}

	/// Добавляет аttribute расстояния между параграфами
	/// - Parameter paragraphSpacing: растояние между параграфами
	@discardableResult
	public func setParagraphSpacing(_ paragraphSpacing: CGFloat) -> AttributedStringBuilder {
		paragraphStyle.paragraphSpacing = paragraphSpacing
		attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: attributedStringRange)
		return self
	}

	/// Добавляет аttribute переноса строки для всей строки
	/// - Parameter lineBreakMode: перенос строки
	@discardableResult
	public func setLineBreakMode(_ lineBreakMode: NSLineBreakMode) -> AttributedStringBuilder {
		paragraphStyle.lineBreakMode = lineBreakMode
		attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: attributedStringRange)
		return self
	}

	/// Добавляет аttribute выравнивания строки для всей строки
	/// - Parameter alignment: выравнивание
	@discardableResult
	public func setAlignment(_ alignment: NSTextAlignment) -> AttributedStringBuilder {
		paragraphStyle.alignment = alignment
		attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: attributedStringRange)
		return self
	}

	/// Добавляет аttribute направление написания для всей строки
	/// - Parameter direction: Направление написания
	@discardableResult
	public func setDirection(_ direction: NSWritingDirection) -> AttributedStringBuilder {
		paragraphStyle.baseWritingDirection = direction
		attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: attributedStringRange)
		return self
	}

	/// Добавляет аttribute высоты строки для всей строки
	/// - Parameter lineHeightMultiple: множитель высоты строки
	@discardableResult
	public func setLineHeightMultiple(_ lineHeightMultiple: CGFloat) -> AttributedStringBuilder {
		paragraphStyle.lineHeightMultiple = lineHeightMultiple
		attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: attributedStringRange)
		return self
	}

	/// DescriptionДобавляет обводку текста
	/// - Parameters:
	///   - strokeColor: цвет обводки
	///   - foregroundColor: цвет текста внутри обводки
	///   - strokeWidth: ширина линии обводки
	@discardableResult
	public func setStrokeAttribute(
		strokeColor: UIColor,
		foregroundColor: UIColor,
		strokeWidth: CGFloat
	) -> AttributedStringBuilder {
		attributedString.addAttributes([
			.strokeColor: strokeColor,
			.foregroundColor: foregroundColor,
			.strokeWidth: strokeWidth
		], range: attributedStringRange)
		return self
	}

	/// Добавляет картинку в строку
	/// - Parameters:
	///   - image: картинка
	///   - bounds: границы
	///   - atBegin: картинку добавить в начало или конец
	public func addImage(
		_ image: UIImage?,
		bounds: CGRect,
		atBegin: Bool = false
	) -> AttributedStringBuilder {
		let attachment = NSTextAttachment(data: nil, ofType: nil)
		attachment.image = image
		attachment.bounds = bounds

		if atBegin {
			let attachmentAttributedString = NSMutableAttributedString(string: "")
			attachmentAttributedString.append(NSAttributedString(attachment: attachment))
			attachmentAttributedString.append(NSAttributedString(string: "  "))
			attachmentAttributedString.append(attributedString)

			attributedString = attachmentAttributedString
		} else {
			attributedString.append(NSAttributedString(string: "  "))
			attributedString.append(NSAttributedString(attachment: attachment))
			attributedString.append(NSAttributedString(string: ""))
		}

		return self
	}

	/// Добавляет к текущей строке строку с заданными атрибутами
	/// - Parameters:
	///   - string: строка
	///   - attributes: атрибуты
	@discardableResult
	public func append(_ string: String, attributes: Attributes) -> AttributedStringBuilder {
		let addedString = NSAttributedString(
			string: string,
			attributes: attributes
		)

		attributedString.append(addedString)
		return self
	}

	/// Добавляет аttributed строку в текущую
	/// - Parameter attributedString: аttributed строка
	@discardableResult
	public func append(_ attributedString: NSAttributedString) -> AttributedStringBuilder {
		self.attributedString.append(attributedString)
		return self
	}

	/// Добавляет аttributes в заданный промежуток
	/// - Parameters:
	///   - attributes: аttributes
	///   - range: промежуток
	@discardableResult
	public func add(_ attributes: [NSAttributedString.Key: Any], range: NSRange) -> AttributedStringBuilder {
		attributedString.addAttributes(attributes, range: range)
		return self
	}

	/// Добавляет подчеркивание строки в заданном промежутке + цвет
	/// - Parameters:
	///   - style: стиль подчеркивания
	///   - color: цвет
	///   - range: промежуток
	@discardableResult
	public func setUnderline(
		style: NSUnderlineStyle,
		color: UIColor,
		range: NSRange
	) -> AttributedStringBuilder {
		attributedString.addAttributes([
			.underlineStyle: style.rawValue,
			.underlineColor: color
		], range: range)
		return self
	}

	/// Добавляет интерлиньяж
	/// - Parameters:
	///   - lineHeight: высота строки в пикселях
	///   - font: шрифт
	@discardableResult
	public func setInterliningFont(_ lineHeight: CGFloat, _ font: UIFont) -> AttributedStringBuilder {
		paragraphStyle.minimumLineHeight = CGFloat(lineHeight)
		paragraphStyle.maximumLineHeight = CGFloat(lineHeight)

		let baselineShift: CGFloat
		if #available(iOS 16.4, *) {
			baselineShift = 2
		} else {
			baselineShift = 4
		}

		attributedString.addAttributes(
			[
				.baselineOffset: (lineHeight - font.lineHeight) / baselineShift,
				.paragraphStyle: paragraphStyle
			],
			range: attributedStringRange
		)
		return self
	}

	/// Создает NSAttributedString
	/// - Returns: NSAttributedString
	public func build() -> NSAttributedString {
		return NSAttributedString(attributedString: attributedString)
	}
}

