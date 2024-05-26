//
//  LocationManager.swift
//  PROGulky
//
//  Created by Тазенков Иван on 26.05.2024.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
	static var shared = LocationManager()
	var location: CLLocation?
	private var manager: CLLocationManager {
		let manager = CLLocationManager()
		manager.delegate = self
		return manager
	}

	func requestLocation() {
		manager.requestLocation()
	}
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.location = locations.first
	}
	func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
		debugPrint("[DEBUG] CLLocationManager error: \(error)")
	}
}


extension CLLocation {
	var coordinatesToString: String {
		return "\(coordinate.latitude),\(coordinate.longitude)"
	}
}
