//
//  UbicacionViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 28/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import MapKit
import Alamofire


class Annotation : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    
    
    
    init(coordinate: CLLocationCoordinate2D, title:String?){
        self.coordinate = coordinate
        self.title = title
        
        super.init()
    }
}

class UbicacionViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationmanager = CLLocationManager()
    var usuarioid:Int?
    var usuarioname:String?
    var lat:Double?
    var lon:Double?
    
    var rooms:[Room] = []
    let token = UserDefaults.standard.string(forKey: "token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(usuarioid)
        print(usuarioname)
        loadData()

        
        
        
        
    }
    
    private func loadMapa(){
        
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
                        print("SALAS CLINICAS: \(rooms)")
                        
                        self.rooms = rooms
                        //let especialidad:Especialidad = self.especialidades
                        
                        
                        for i in rooms{
                           print(i.doctors_users_id!)
                            
                            if(Int(i.doctors_users_id!) == self.usuarioid){
                                print("ENCONTRADO EL ID")
                                
                                
                                print(i.id)
                                
                                
                                
                                Alamofire.request("https://proyectintegrador-rmiya.cs50.io/api/rooms/\(i.id!)", headers: headers).validate().responseObject{ (response: DataResponse<Room>) in
                                    switch response.result {
                                    case .success:
                                        
                                        if let json = response.result.value {
                                            
                                            print("JSON: \(json)") // serialized json response
                                            
                                            if let uniqueroom = response.result.value {
                                                // That was all... You now have a User object with data
                                                print("ROOM \(uniqueroom.latitud)")
                                                
                                                
                                                self.lon = Double(uniqueroom.longitud!)
                                                self.lat = Double(uniqueroom.latitud!)
                                                
                                                
                                                self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
                                                
                                                
                                                
                                                //let oficinacoordinate = CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0942)
                                                let oficinacoordinate = CLLocationCoordinate2DMake(self.lon!, self.lat!)
                                                let oficinaannotation = Annotation(coordinate: oficinacoordinate, title:"Oficina de \(self.usuarioname!)")
                                                
                                                self.mapView.addAnnotation(oficinaannotation)
                                                let region = MKCoordinateRegionMakeWithDistance(oficinacoordinate, 1000, 1000)
                                                self.mapView.setRegion(region, animated: true)
                                        
                                            }
                                            
                                        }
                                    case .failure(let error):
                                        print("TENEMOS UN GRAN ERROR", error)
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            
                            //let room:Room = self.rooms
                            
                        }
                        //self.especialidadesTableView.reloadData()
                        
                        
                    }
                }
            case .failure(let error):
                print("TENEMOS UN GRAN ERROR", error)
                
            }
            
        }
        
    }
    
    

    

}
