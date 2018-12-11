//
//  ProfileViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 26/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialCards
import SDWebImage

class ProfileViewController: UIViewController, DemoController {

    weak var menuController: CariocaController?
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var perfilImage: UIImageView!
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var cardImage: MDCCard!
    
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var correoLabel: UILabel!
    @IBOutlet weak var apellidoLabel: UILabel!
    let token = UserDefaults.standard.string(forKey: "token")
    
    var usuarioid:Int?
    var usuarioname:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loadCard()
        loadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    private func loadCard(){
        cardImage.cornerRadius = 10
        cardImage.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cardImage.setShadowColor(UIColor.black, for: .highlighted)
    }
    
    
    
    private func loadData(){
        
        let headers: HTTPHeaders = [
            "x-access-token": token!
        ]
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/api/users/\(usuarioid!)", headers: headers).validate().responseObject{ (response: DataResponse<Usuario>) in
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
                        self.profileImage.sd_setImage(with: URL(string: pictureURL!), placeholderImage: UIImage(named: "ic_profile"))
                        self.usuarioname = usuario.name
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
    
    @IBAction func mapsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "mostrarUbicacion", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "mostrarUbicacion" {
            if(sender != nil){
                //var id = sender as! Int
                //id = usuarioid!
                let viewController = segue.destination as! UbicacionViewController
                viewController.usuarioid = usuarioid
                viewController.usuarioname = usuarioname
            }
        }
        
    }
    
    
}
