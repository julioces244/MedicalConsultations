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
    
    var especialidadid = 0
    
    @IBOutlet var specialitiesButtons: [UIButton]!
    
    @IBAction func handleSelection(_ sender: UIButton) {
        
        specialitiesButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    enum Citys: String {
        
        
        
        
        case mg = "Medicina General"
        case psi = "Psiquiatría"
    }
    
    
    @IBAction func specialityTapped(_ sender: UIButton) {
        
        guard let title = sender.currentTitle, let city = Citys(rawValue: title) else {
            return
        }
            
            switch city {
            case .mg:
                
                especialidadid = 1
                print("Boston")
                specialitiesButtons.forEach { (button) in
                    UIView.animate(withDuration: 0.3, animations: {
                        button.isHidden = !button.isHidden
                        self.view.layoutIfNeeded()
                    })
                }
                
            case .psi:
                
                especialidadid = 2
                print("Psiquiatria")
                specialitiesButtons.forEach { (button) in
                    UIView.animate(withDuration: 0.3, animations: {
                        button.isHidden = !button.isHidden
                        self.view.layoutIfNeeded()
                    })
                }
                
                
            default:
                print("San fran")
            }
    }
    
    
    @IBAction func registroButton(_ sender: Any) {
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
            valortipousuario = 2;
        }else{
            valortipousuario = 1;
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
            "perfil_id" : valortipousuario,
            "specialities_id" : especialidadid
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
                if response.response?.statusCode == 400 {
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                        
                    }
                    
                    let alertController : UIAlertController = UIAlertController(title: "Alerta", message: "Ya existe un usuario con ese correo", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                if response.response?.statusCode == 412 {
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                        
                    }
                    let alertController : UIAlertController = UIAlertController(title: "Alerta", message: "Campo invalido", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
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
