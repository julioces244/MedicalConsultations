//
//  GetLocationViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 5/12/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class GetLocationViewController: UIViewController, UISearchBarDelegate {

    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    var searchBarController : UISearchController!
    let geocoder = CLGeocoder()
    var adress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        
        //let tap = UITapGestureRecognizer(target:self, action:#selector(self.action(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    
    @IBAction func locaizame() {
        initLocation()
    }
    
    func initLocation() {
        
        let permiso = CLLocationManager.authorizationStatus()
        
        if permiso == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if permiso == .denied {
            alertLocation(tit: "Error de localización", men: "Actualmente tiene denegada la localización del dispositivo.")
        } else if permiso == .restricted {
            alertLocation(tit: "Error de localización", men: "Actualmente tiene restringida la localización del dispositivo.")
        } else {
            
            guard let currentCoordinate = locationManager.location?.coordinate else { return }
            
            let region = MKCoordinateRegionMakeWithDistance(currentCoordinate, 500 , 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func alertLocation(tit: String, men: String) {
        
        let alerta = UIAlertController(title: tit, message: men, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alerta.addAction(action)
        self.present(alerta, animated: true, completion: nil)
    }
}

extension GetLocationViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error de localización")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    @objc func action(gestureRecognizer: UIGestureRecognizer) {
        
        self.mapView.removeAnnotations(mapView.annotations)
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        geocoderLocation(newLocation: CLLocation(latitude: newCoords.latitude, longitude: newCoords.longitude))
        
        let latitud = String(format: "%.6f", newCoords.latitude)
        let longitud = String(format: "%.6f", newCoords.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoords
        annotation.title = adress
        annotation.subtitle = "Latitud: \(latitud) Longitud: \(longitud)"
        mapView.addAnnotation(annotation)
    }
    
    func geocoderLocation(newLocation: CLLocation) {
        var dir  = ""
        geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            if error == nil {
                dir = "No se ha podido determinar la dirección"
            }
            if let placemark = placemarks?.last {
                dir = self.stringFromPlacemark(placemark: placemark)
            }
            self.adress = dir
        }
        
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        var line = ""
        
        if let p = placemark.thoroughfare {
            line += p + ", "
        }
        if let p = placemark.subThoroughfare {
            line += p + " "
        }
        if let p = placemark.locality {
            line += " (" + p + ")"
        }
        return line
    }
    
    
    @IBAction func showSearchBar() {
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.hidesNavigationBarDuringPresentation = false
        self.searchBarController.searchBar.delegate = self
        present(searchBarController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if mapView.annotations.count > 1 {
            self.mapView.removeAnnotations(mapView.annotations)
        }
        
        geocoder.geocodeAddressString(searchBar.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
            
            if error == nil {
                let placemark = placemarks?.first
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark?.location?.coordinate)!
                annotation.title = searchBar.text!
                
                let spam = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: annotation.coordinate, span: spam)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            } else {
                print("Error")
            }
        }
    }
    
    
}

extension GetLocationViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationID = "AnnotationID"
        
        var annotationView : MKAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "img_pin2")
        }
        return annotationView
    }
}
