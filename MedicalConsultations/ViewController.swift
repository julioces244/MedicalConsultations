//
//  ViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 2/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    
    @IBOutlet weak var correoTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    

    @IBAction func iniciarSesion(_ sender: Any) {
        
        let email = correoTextField.text
        let pass = passwordTextField.text
        
        let parameters: Parameters = [
            "email" : email,
            "password" : pass
        ]
        
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                self.performSegue(withIdentifier: "iniciarSegue", sender: sender)
                if let json = response.result.value {
                    
                    
                    //let jsonObject:Dictionary = json as! Dictionary<String, Any>
                    
                    let user = Usuario()
                    var tok = ""
                    var id = 0
                    
                    print("JSON: \(json)") // serialized json response
                    let logindata = json as! NSDictionary
                    tok = logindata["token"] as! String
                    id = Int(logindata["id"] as! NSNumber)
                    //print(user)
                    //print(user.auth)
                    
                    UserDefaults.standard.set(tok, forKey: "token")
                    UserDefaults.standard.set(id, forKey: "id")
                    
                    
                    
                }
            case .failure(let error):
                print("TENEMOS UN GRAN ERROR", error)
            }
        }
    }
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "iniciarSegue" {
            let siguienteVC = segue.destination as! MainViewController
            siguienteVC.info = "HOOOOOOOOO"
        }
    }
        
        
        
        /*Alamofire.request("https://proyectintegrador-rmiya.cs50.io/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            print("INGRESANDO A LA APLICACION")
            
        }*/
        
    
    
        
    
        
        /*Alamofire.request("https://proyectintegrador-rmiya.cs50.io/users").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }*/
        
        
    
    
   
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

