//
//  InicioViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 6/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit

class InicioViewController: UIViewController, DemoController{
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let token = UserDefaults.standard.string(forKey: "token")
    
    weak var menuController: CariocaController?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("------------------")
        print(token)
        print("------------------")
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    

}
    

    
   


