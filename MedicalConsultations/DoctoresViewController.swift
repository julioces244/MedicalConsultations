//
//  DoctoresViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 26/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


class DoctoresViewController: UITableViewController {
    
    
    @IBOutlet var doctoresTableView: UITableView!
    var especialidadid:Int?
    
    var usuarios:[Usuario] = []
    
    let token = UserDefaults.standard.string(forKey: "token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("INGRESANDO A DOCTORES VIEW CONTROLLER")
        loadData()
       
    }

    public func loadData(){
        
        let headers: HTTPHeaders = [
            "x-access-token": token!
        ]
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/specialities/\(especialidadid!)", headers: headers).validate().responseArray{ (response: DataResponse<[Usuario]>) in
            switch response.result {
            case .success:
                
                if let json = response.result.value {
                    
                    print("JSON: \(json)") // serialized json response
                    
                    if let usuarios = response.result.value {
                        // That was all... You now have a User object with data
                        print("USUARIOS: \(usuarios)")
                        print(self.especialidadid)
                        self.usuarios = usuarios
                        self.doctoresTableView.reloadData()
                        
                        
                    }
                }
            case .failure(let error):
                print("TENEMOS UN GRAN ERROR", error)
                
            }
            
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! DoctoresTableViewCell
        
        let usuario:Usuario = self.usuarios[indexPath.row]
        
        if(usuario.id != nil){

            //let pictureURL = "http://proyectintegrador-rmiya.c9users.io/2018-11-10T15:54:00.590Zmanprofile.jpg"
            
            let pictureURL = usuario.image
            print(pictureURL)
            print("-----")
            
            cell.pictureImage.sd_setImage(with: URL(string: pictureURL!), placeholderImage: UIImage(named: "ic_profile"))
            
            cell.pictureImage.layer.borderWidth = 1
            cell.pictureImage.layer.masksToBounds = false
            cell.pictureImage.layer.borderColor = UIColor.black.cgColor
            cell.pictureImage.layer.cornerRadius = cell.pictureImage.frame.height/2
            cell.pictureImage.clipsToBounds = true
        }
        
            cell.nombreLabel.text =  usuario.name
            cell.apellidoLabel.text = usuario.lastname
        
            return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario:Usuario = self.usuarios[indexPath.row]
        self.performSegue(withIdentifier: "mostrarUsuarioSegue", sender: usuario.id)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "mostrarUsuarioSegue" {
            if(sender != nil){
                let id = sender as! Int
                let viewController = segue.destination as! ProfileViewController
                viewController.usuarioid = id
            }else{
                let alertController : UIAlertController = UIAlertController(title: "Información no disponible", message: "La información de este curso aún no se encuentra disponible.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
}
