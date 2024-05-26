//
//  CameraListener.swift
//  PROGulky
//
//  Created by Иван Тазенков on 22.11.2022.
//

import Foundation
import YandexMapsMobile

// MARK: - ListenerDelegate

protocol ListenerDelegate: AnyObject {
    func azimuthChanged(with cameraPosition: YMKCameraPosition)
}

// MARK: - CameraListener

final class CameraListener: NSObject, YMKMapCameraListener {
    var delegate: ListenerDelegate?

    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        delegate?.azimuthChanged(with: cameraPosition)
    }
}

extension CameraListener: YMKUserLocationObjectListener {
	func onObjectAdded(with view: YMKUserLocationView) {
//		view.arrow.setIconWith(UIImage(named:"user_arrow")!)

//		let pinPlacemark = view.pin.useCompositeIcon()
//
//		pinPlacemark.setIconWithName("icon",
//									 image: UIImage(named:"Icon")!,
//									 style:YMKIconStyle(
//										anchor: CGPoint(x: 0, y: 0) as NSValue,
//										rotationType:YMKRotationType.rotate.rawValue as NSNumber,
//										zIndex: 0,
//										flat: true,
//										visible: true,
//										scale: 1.5,
//										tappableArea: nil))
//
//		pinPlacemark.setIconWithName(
//			"pin",
//			image: UIImage(named:"SearchResult")!,
//			style:YMKIconStyle(
//				anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
//				rotationType:YMKRotationType.rotate.rawValue as NSNumber,
//				zIndex: 1,
//				flat: true,
//				visible: true,
//				scale: 1,
//				tappableArea: nil))

		view.accuracyCircle.fillColor = .clear
	}
	
	func onObjectRemoved(with view: YMKUserLocationView) {}
	
	func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}
