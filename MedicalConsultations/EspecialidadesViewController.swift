//
//  EspecialidadesViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 6/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import Alamofire

class EspecialidadesViewController: UITableViewController, DemoController{
    
    @IBOutlet var especialidadesTableView: UITableView!
    weak var menuController: CariocaController?
    
    //@IBOutlet weak var especialidadesTableView: UITableView!
    
    var especialidades:[Especialidad] = []
    
    let token = UserDefaults.standard.string(forKey: "token")

    override func viewDidLoad() {
        super.viewDidLoad()
        print("INGRESANDO A ESPECIALIDADES CONTROLLER")
        loadData()
    }
    
    
    
    private func loadData(){
        
        let headers: HTTPHeaders = [
            "x-access-token": token!
        ]
        
        Alamofire.request("https://proyectintegrador-rmiya.cs50.io/specialities", headers: headers).validate().responseArray{ (response: DataResponse<[Especialidad]>) in
            switch response.result {
            case .success:
                
                if let json = response.result.value {
                    
                    print("JSON: \(json)") // serialized json response
                    
                    if let especialidades = response.result.value {
                        // That was all... You now have a User object with data
                        print("ESPECIALIDAD: \(especialidades)")
                        
                        self.especialidades = especialidades
                        self.especialidadesTableView.reloadData()
                        
                        
                    }
                }
                    case .failure(let error):
                    print("TENEMOS UN GRAN ERROR", error)
                
            }
            
        }
        
    }
    
    //override func numberOfSections(in tableView: UITableView) -> Int {
        //return ViewDrawer.showEmptyMessage(in: tableView, show: self.especialidades.isEmpty)
    //}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.especialidades.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EspecialidadCell", for: indexPath) as! EspecialidadesTableViewCell
        
        let especialidad:Especialidad = self.especialidades[indexPath.row]
        cell.titleLabel.text = especialidad.nombre
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let especialidad:Especialidad = self.especialidades[indexPath.row]
        self.performSegue(withIdentifier: "mostrarDoctoresSegue", sender: especialidad.id)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.s
        if segue.identifier == "mostrarDoctoresSegue" {
            if(sender != nil){
                let id = sender as! Int
                let viewController = segue.destination as! DoctoresViewController
                viewController.especialidadid = id
            }else{
                let alertController : UIAlertController = UIAlertController(title: "Información no disponible", message: "La información de este curso aún no se encuentra disponible.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
}
