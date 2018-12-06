//
//  AllUbicacionViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 3/12/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import MaterialComponents

class AllUbicacionViewController: UIViewController, DemoController {
    
    
    @IBOutlet weak var cardView: MDCCard!
    
    weak var menuController: CariocaController?

    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.cornerRadius = 10
        cardView.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cardView.setShadowColor(UIColor.black, for: .highlighted)

    }
    
    
    @IBAction func mostrarConsultorios(_ sender: Any) {
        
        self.performSegue(withIdentifier: "mostrarUbicacionesSegue", sender: self)
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}



