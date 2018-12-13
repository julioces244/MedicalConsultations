//
//  OverviewProfileViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 4/12/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCards
import Alamofire
import SDWebImage

class OverviewProfileViewController: UIViewController, DemoController {

    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var cardImage2: MDCCard!
    @IBOutlet weak var cardImage: MDCCard!
    weak var menuController: CariocaController?
    let token = UserDefaults.standard.string(forKey: "token")
    let id = UserDefaults.standard.integer(forKey: "id")
    let perfil = UserDefaults.standard.string(forKey: "perfil_id")
    
    
    @IBOutlet weak var nombreLabel: UILabel!
    
    @IBOutlet weak var apellidoLabel: UILabel!
    
    @IBOutlet weak var correoLabel: UILabel!
    
    @IBOutlet weak var telefonoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLocation.isEnabled = false
       
        
        if(perfil == "Paciente"){
            cardImage2.isHidden = true
            imageViewProfile.layer.cornerRadius = imageViewProfile.frame.size.width/2
            imageViewProfile.clipsToBounds = true
            imageViewProfile.layer.borderColor = UIColor.white.cgColor
            imageViewProfile.layer.borderWidth = 5.0
            
            loadCard()
            loadData()
        }else{
            imageViewProfile.layer.cornerRadius = imageViewProfile.frame.size.width/2
            imageViewProfile.clipsToBounds = true
            imageViewProfile.layer.borderColor = UIColor.white.cgColor
            imageViewProfile.layer.borderWidth = 5.0
            
            loadCard()
            loadData()
            loadData2()
            print("ENTRANDO OVERVIEW")
            print(id)
        }
        
        
        
        
        
        
        
      
    }
    
    
    @IBAction func salir(_ sender: Any) {
        self.performSegue(withIdentifier: "returnOverviewProfile", sender: sender)
        
    }
    
    private func loadCard(){
        cardImage.cornerRadius = 10
        cardImage.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cardImage.setShadowColor(UIColor.black, for: .highlighted)
        cardImage.setBorderColor(UIColor.blue, for: .normal)
        
        cardImage2.cornerRadius = 10
        cardImage2.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cardImage2.setShadowColor(UIColor.black, for: .highlighted)
        cardImage2.setBorderColor(UIColor.blue, for: .normal)
        
    }
    
    
    
    @IBAction func mostrarGetLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "mostrarGetLocation", sender: self)
    }
    
    private func loadData(){
        
        let headers: HTTPHeaders = [
            "x-access-token": token!
        ]
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/api/users/\(id)", headers: headers).validate().responseObject{ (response: DataResponse<Usuario>) in
            switch response.result {
            case .success:
                
                if let json = response.result.value {
                    
                    print("JSON: \(json)") // serialized json response
                    
                    if let usuario = response.result.value {
                        // That was all... You now have a User object with data
                        print("User: \(usuario)")
                        
                        
                        
                        self.nombreLabel.text = usuario.name
                        self.apellidoLabel.text = usuario.lastname
                        self.correoLabel.text = usuario.email
                        self.telefonoLabel.text = usuario.phone
                        let pictureURL = usuario.image
                        self.imageViewProfile.sd_setImage(with: URL(string: pictureURL!), placeholderImage: UIImage(named: "ic_profile"))
                        
                        
                        
                        
                        //self.usuarioname = usuario.name
                        //print("Bienvenido \(usuario.name!)")
                        
                        // picture fixed
                        //if(pictureURL != nil){
                        //  user.picture = pictureURL?.absoluteString
                        //}
                    }
                    
                }
            case .failure(let error):
                print("TENEMOS UN GRAN ERROR", error)
                
            }
            
        }
        
    }
    
    
    private func loadData2(){
        
        let headers: HTTPHeaders = [
            "x-access-token": token!
        ]
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/api/rooms1/\(id)", headers: headers).validate().responseObject{ (response: DataResponse<Room>) in
            switch response.result {
            case .success:
                
                if let json = response.result.value {
                    
                    print("JSON: \(json)") // serialized json response
                    
                    if let room = response.result.value {
                        // That was all... You now have a User object with data
                        print("Consultorio: \(room)")
                        self.locationLabel.text = room.address
                  
                    }
                    
                }
            case .failure(let error):
                print("TENEMOS UN GRAN ERROR", error)
                if response.response?.statusCode == 404 {
                    self.btnLocation.isEnabled = true
                    
                    let alertController : UIAlertController = UIAlertController(title: "Alerta", message: "Agregue su ubicacion", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    


}
