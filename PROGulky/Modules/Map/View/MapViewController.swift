//
//  MapViewController.swift
//  PROGulky
//
//  Created by Ivan Tazenkov on 21/11/2022.
//

import UIKit
import YandexMapsMobile
import SnapKit

// MARK: - MapViewController

final class MapViewController: UIViewController {
    private var mapView: YMKMapView!
    var output: MapViewOutput!

    private let button = UIButton()
    private let button2 = UIButton()
    private let listener: CameraListener = .init()
	private var locationLayer: YMKUserLocationLayer?

    private enum Constants {
        enum Compass {
            static let bottomOffset: CGFloat = -100
            static let heightWidth: CGFloat = 40
            static let trailingOffset: CGFloat = -24
        }

		enum Location {
			static let size: CGFloat = 80
		}

        static let animationDuration = 0.170

        static let longAnimationDuration: Float = 1
        static let zoom: Float = 17
        static let degreesInHalfPi: Float = 180
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMaps()
        setupButton()
        output.didLoadView()
		LocationManager.shared.requestLocation()
    }

    private func setupMaps() {
        mapView = YMKMapView(frame: view.bounds, vulkanPreferred: isM1Simulator())
        mapView.mapWindow.map.mapType = .map
        view.addSubview(mapView)
		let mapKit = YMKMapKit.sharedInstance()
		locationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
		locationLayer?.setVisibleWithOn(true)
		locationLayer?.isHeadingEnabled = false
//		userLocationLayer.setAnchorWithAnchorNormal(
//			CGPoint(x: view.frame.midX, y: view.frame.midY),
//			anchorCourse: CGPoint(x: view.frame.midX, y: view.frame.midY)
//		)
//		userLocationLayer.setAnchorWithAnchorNormal(
//			CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
//			anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
		locationLayer?.setObjectListenerWith(listener)
        listener.delegate = self

        mapView.mapWindow.map.addCameraListener(with: listener)
    }

    private func setupButton() {
        view.addSubview(button)
        view.bringSubviewToFront(button)
        button.setImage(UIImage(named: "compass")?
            .withRenderingMode(.alwaysOriginal), for: .normal)
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
                .offset(Constants.Compass.bottomOffset)
            make.trailing.equalToSuperview()
                .offset(Constants.Compass.trailingOffset)
            make.height.equalTo(Constants.Compass.heightWidth)
            make.width.equalTo(Constants.Compass.heightWidth)
        }
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) 

		view.addSubview(button2)
        view.bringSubviewToFront(button2)
        button2.setImage(
			UIImage(systemName: "location.circle.fill")?
				.withTintColor(.blue, renderingMode: .alwaysTemplate)
				.applyingSymbolConfiguration(.init(pointSize: Constants.Compass.heightWidth)),
			for: .normal
			)
        button2.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
                .offset(Constants.Compass.bottomOffset)
            make.leading.equalToSuperview()
                .offset(-Constants.Compass.trailingOffset)
			make.height.equalTo(Constants.Compass.heightWidth)
			make.width.equalTo(Constants.Compass.heightWidth
			)
        }
        button2.addTarget(self, action: #selector(button2Tapped(_:)), for: .touchUpInside)
    }

    private func isM1Simulator() -> Bool {
        false
//        (TARGET_IPHONE_SIMULATOR & TARGET_CPU_ARM64) != 0
    }

    @objc
    private func buttonTapped(_ sender: UIButton) {
        let currentCameraPosition = mapView.mapWindow.map.cameraPosition
        var cameraPosition: YMKCameraPosition

        cameraPosition = YMKCameraPosition(
            target: currentCameraPosition.target,
            zoom: currentCameraPosition.zoom,
            azimuth: 0,
            tilt: currentCameraPosition.tilt
        )

        mapView.mapWindow.map.move(
            with: cameraPosition,
            animationType: YMKAnimation(type: YMKAnimationType.linear,
                                        duration: Float(Constants.animationDuration))
        )
    }
    @objc
    private func button2Tapped(_ sender: UIButton) {
		guard var cameraPosition = locationLayer?.cameraPosition() else { return }
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
				target: cameraPosition.target,
				zoom: cameraPosition.zoom > Constants.zoom ? cameraPosition.zoom : Constants.zoom,
				azimuth: cameraPosition.azimuth,
				tilt: cameraPosition.tilt
			),
            animationType: YMKAnimation(type: YMKAnimationType.linear,
                                        duration: Float(Constants.animationDuration))
        )
    }
}

// MARK: MapViewInput

extension MapViewController: MapViewInput {
    func showAlert(with alertMessage: String) {
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func routeRecieved(route: YMKMasstransitRoute, points: [YMKPoint]) {
        let mapObjects = mapView.mapWindow.map.mapObjects
        mapObjects.addPolyline(with: route.geometry)
        if !points.isEmpty {
            for (index, point) in points.enumerated() {
                mapObjects.addPlacemark(with: point, image: MapView.pointImage(index + 1))
            }
        }
		_ = points.reduce(YMKPoint(latitude: 0, longitude: 0)) { partialResult, point in
            YMKPoint(
                latitude: partialResult.latitude + point.latitude,
                longitude: partialResult.longitude + point.longitude
            )
        }

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: points[0],
                                    zoom: Constants.zoom,
                                    azimuth: 0,
                                    tilt: 0)
        )
    }
}

// MARK: ListenerDelegate

extension MapViewController: ListenerDelegate {
    func azimuthChanged(with cameraPosition: YMKCameraPosition) {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.button.transform = CGAffineTransform(
                rotationAngle: CGFloat(-cameraPosition.azimuth * .pi / Constants.degreesInHalfPi)
            )
        }
    }
}
