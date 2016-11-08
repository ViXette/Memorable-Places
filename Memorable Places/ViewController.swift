//
//  ViewController.swift
//  Memorable Places
//
//  Created by VX on 27/10/2016.
//  Copyright © 2016 VXette. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	var place :Dictionary<String, String>? = nil

	@IBOutlet weak var map: MKMapView!
	
	var manager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
		uilpgr.minimumPressDuration = 2
		
		map.addGestureRecognizer(uilpgr)
		
		if place == nil {
			manager.delegate = self
			manager.desiredAccuracy = kCLLocationAccuracyBest
			manager.requestWhenInUseAuthorization()
			manager.startUpdatingLocation()
		} else {
			if let name = place!["name"] {
				if let lon = place!["lon"] {
					if let lat = place!["lat"] {
						if let longitude = Double(lon) {
							if let latitude = Double(lat) {
								let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
								let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
								let region = MKCoordinateRegion(center: coordinate, span: span)
								
								self.map.setRegion(region, animated: true)
								
								let annotation = MKPointAnnotation()
								annotation.coordinate = coordinate
								annotation.title = name
								self.map.addAnnotation(annotation)
							}
						}
					}
				}
			}
		}
	}
	
	func longpress(gestureRecognizer :UIGestureRecognizer)
	{
		if gestureRecognizer.state == UIGestureRecognizerState.began {
			let touchPoint = gestureRecognizer.location(in: self.map)
			
			let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
			
			let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
			var title = ""
			CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
				if error != nil {
					print(error!)
				} else {
					if let placemark = placemarks?[0] {
						if placemark.subThoroughfare != nil {
							title += placemark.subThoroughfare! + " "
						}
						if placemark.thoroughfare != nil {
							title += placemark.thoroughfare!
						}
					}
				}
				
				if title == "" {
					title = "Added \(NSDate())"
				}
				
				let annotation = MKPointAnnotation()
				annotation.coordinate = newCoordinate
				annotation.title = title
				self.map.addAnnotation(annotation)
				
				places.append(["name": title, "lat": String(newCoordinate.latitude), "lon": String(newCoordinate.longitude)])
				
				UserDefaults.standard.set(places, forKey: "places")
			})
			
			

		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude,
		                                      longitude: locations[0].coordinate.longitude)
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: location, span: span)
		
		self.map.setRegion(region, animated: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

