//
//  MapViewBuilder.swift
//  PROGulky
//
//  Created by Ivan Tazenkov on 23.04.2023.
//

import Foundation
import UIKit
import SwiftUI
import YandexMapsMobile

// MARK: - MapView

final class MapView: UIView {
    var mapView: YMKMapView!
    var polyline = YMKPolyline(points: [])
    var points = [YMKPoint]()

    init() {
        super.init(frame: .zero)
        setupMap()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateMap() {
        setupRoute()
    }

    private func setupMap() {
        mapView = YMKMapView(frame: bounds, vulkanPreferred: false)
        mapView.mapWindow.map.mapType = .map
        addSubview(mapView)
    }

    func setupRoute() {
        let mapObjects = mapView.mapWindow.map.mapObjects
        mapObjects.addPolyline(with: polyline)
        if !points.isEmpty {
			var targetLatitude = 0.0
			var targetLongitude = 0.0
            for (index, point) in points.enumerated() {
                mapObjects.addPlacemark(with: point, image: Self.pointImage(index + 1))
				targetLatitude += point.latitude
				targetLongitude += point.longitude
            }
			targetLatitude /= Double(points.count)
			targetLongitude /= Double(points.count)
			let targetPoint = YMKPoint(latitude: targetLatitude, longitude: targetLongitude)
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: targetPoint,
                                        zoom: 13.5,
                                        azimuth: 0,
                                        tilt: 0)
            )
        }
    }

    static func pointImage(_ num: Int) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (num as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: 12 * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + 3 * scale
        let externalRadius = internalRadius + 3 * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)

        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!

        ctx.setFillColor(UIColor.blue.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)
        ))

        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)
        ))

        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size
            ),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
}

// MARK: - RepresentedMapView

struct RepresentedMapView: UIViewRepresentable {
    var polyline = YMKPolyline(points: [])
    var points = [YMKPoint]()
    var mapView = MapView()

    func makeUIView(context: Context) -> MapView {
        mapView.isUserInteractionEnabled = false
        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        uiView.polyline = polyline
        uiView.points = points
        uiView.setupRoute()
    }
}
