//
//  ShowAllUbicacionViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 3/12/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import MapKit
import Alamofire




class ShowAllUbicacionViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapAllView: MKMapView!
    var ubication = CLLocationManager()
    
    let token = UserDefaults.standard.string(forKey: "token")
    var rooms:[Room] = []
    var lat:Double?
    var lon:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        //let locationManager = CLLocationManager()
        ubication.delegate = self
        ubication.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            ubication.requestAlwaysAuthorization()
            ubication.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = ubication.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 1000, 1000)
            mapAllView.setRegion(viewRegion, animated: true)
            
        }
        
        //self.ubication = ubication
        
        DispatchQueue.main.async {
            self.ubication.startUpdatingLocation()
            self.mapAllView.showsUserLocation = true
        }
    }
    
    private func loadData(){
        
        let headers: HTTPHeaders = [
            "x-access-token": token!
        ]
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/api/rooms", headers: headers).validate().responseArray{ (response: DataResponse<[Room]>) in
            switch response.result {
            case .success:
                
                if let json = response.result.value {
                    
                    print("JSON: \(json)") // serialized json response
                    
                    if let rooms = response.result.value {
                        // That was all... You now have a User object with data
                        print("ROOMS: \(rooms)")
                        self.rooms = rooms
                        
                        
                        for i in rooms{
                            
                            
                            self.lon = Double(i.longitud!)
                            self.lat = Double(i.latitud!)
                            
                            
                            self.mapAllView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
                            
                            
                            
                            //let oficinacoordinate = CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0942)
                            let oficinacoordinate = CLLocationCoordinate2DMake(self.lon!, self.lat!)
                            let oficinaannotation = Annotation(coordinate: oficinacoordinate, title:"Consultorio medico")
                            
                            self.mapAllView.addAnnotation(oficinaannotation)
                            
                            //self.ubication.delegate = self
                            //self.ubication.requestWhenInUseAuthorization()
                            //self.mapAllView.showsUserLocation = true
                            
                            //let region = MKCoordinateRegionMakeWithDistance(oficinacoordinate, 2000, 2000)
                            //self.mapAllView.setRegion(region, animated: true)
                        }
                        
                        //self.rooms = rooms
                        //self.especialidadesTableView.reloadData()
                        
                        
                    }
                }
            case .failure(let error):
                print("TENEMOS UN GRAN ERROR", error)
                
            }
            
        }
        
    }

  

}
