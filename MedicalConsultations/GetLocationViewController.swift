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
    
    @IBOutlet weak var saveLocation: UIButton!
    let id = UserDefaults.standard.integer(forKey: "id")
    var searchBarController : UISearchController!
    let geocoder = CLGeocoder()
    var adress = ""
    var lat = ""
    var lon = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NAVIDAIDIADIAIDAJKDADLWJDJLAWLJDALJKWJLDWJLDWAJLKALJWDWJLKFLJK")
        print(id)
        saveLocation.isEnabled = false
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        
        //let tap = UITapGestureRecognizer(target:self, action:#selector(self.action(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGesture)
        
    }
    
    
    @IBAction func guardarUbicacion(_ sender: Any) {
        print(lat)
        print(lon)
        print(id)
        
        let parameters: Parameters = [
            "latitud" : lat,
            "longitud" : lon,
            "doctors_users_id" : id,
            "address" : adress,
            "condition" : 1,
            "state" : 1
        ]
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/api/rooms", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                if let json = response.result.value {
                    
                    print("JSON: \(json)") // serialized json response
                    
                    let alertController : UIAlertController = UIAlertController(title: "Completado!", message: "Ud. a agregado su ubicación satisfactoriamente", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    //self.view.showToast(toastMessage: "Registro valido", duration: 1.1)
                    //self.performSegue(withIdentifier: "toinicio", sender: sender)
                    self.performSegue(withIdentifier: "returnOverviewProfile", sender: sender)
                    
                }
                
                
            case .failure(let error):
                print("TENEMOS UN GRAN ERROR", error)
            }
        }
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
        
        saveLocation.isEnabled = true
        lat = latitud
        lon = longitud
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
