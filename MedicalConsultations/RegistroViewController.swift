//
//  RegistroViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 2/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Alamofire


class RegistroViewController: UIViewController {
    

    
    @IBOutlet weak var segmentedControlGender: UISegmentedControl!
    
    @IBOutlet weak var segmentedControlTipoUsuario: UISegmentedControl!
    
    
    @IBOutlet weak var nombresTextField: UITextField!
    
    @IBOutlet weak var apellidosTextField: UITextField!
    
    @IBOutlet weak var correoTextField: UITextField!
    
    @IBOutlet weak var contraseñaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func registroButton(_ sender: UIButton) {
        
        //Nombres, Apellidos, Correo & Password
        var correo = correoTextField.text
        var password = contraseñaTextField.text
        var nombres = nombresTextField.text
        var apellidos = apellidosTextField.text
        
        if(nombresTextField.text == ""){
            self.view.showToast(toastMessage: "Por favor ingrese nombres", duration: 1.1)
        }
        if(apellidosTextField.text == ""){
            self.view.showToast(toastMessage: "Por favor ingrese apellidos", duration: 1.1)
        }
       
        if((correoTextField.text!).isValidEmail){
            
        }else{
            self.view.showToast(toastMessage: "Ingrese un correo válido", duration: 1.1)
            
        }
        
        
        //Tipo de genero
        let gender = segmentedControlGender.titleForSegment(at: segmentedControlGender.selectedSegmentIndex)
        
        var valorgender = 0;
        if(gender == "Masculino"){
            valorgender = 1;
        }else{
            valorgender = 2;
        }
        
        
        //Tipo de usuario
        let tipousuario = segmentedControlGender.titleForSegment(at: segmentedControlGender.selectedSegmentIndex)
        
        var valortipousuario = 0;
        if(tipousuario == "Doctor"){
            valortipousuario = 1;
        }else{
            valortipousuario = 2;
        }
        
        
        //let tipousuario =
        
        print(gender!)
        
      /*  let alertManager=UIAlertController(title: nil, message: "Welcome!", preferredStyle: .alert)
        
        self.present(alertManager, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1,
                                      execute: {
                                        alertManager.dismiss(animated: false, completion: nil)
                                        
        })*/
        
        let parameters: Parameters = [
            "name" : nombres,
            "lastname" : apellidos,
            "email" : correo,
            "password" : password,
            "genders_id" : valorgender,
            "perfil_id" : valortipousuario
        ]
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/api/users", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                if let json = response.result.value {
                    
                    
                    //let jsonObject:Dictionary = json as! Dictionary<String, Any>
                    
                    
                    print("JSON: \(json)") // serialized json response
                    self.view.showToast(toastMessage: "Registro valido", duration: 1.1)
                    self.performSegue(withIdentifier: "toinicio", sender: sender)
                    
                    
                }
            case .failure(let error):
                print("TENEMOS UN GRAN ERROR", error)
            }
        }

        
        
    }
    
   
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
