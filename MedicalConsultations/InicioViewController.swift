//
//  InicioViewController.swift
//  MedicalConsultations
//
//  Created by Julio César on 6/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import AVKit
import MaterialComponents

class InicioViewController: UIViewController, DemoController{
    
    
    @IBOutlet weak var cardView: MDCCard!
    
    
    @IBOutlet weak var cardView2: MDCCard!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let token = UserDefaults.standard.string(forKey: "token")
    
    weak var menuController: CariocaController?

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.interactivePopGestureRecognizer.enabled = false
        cardView.cornerRadius = 10
        cardView.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cardView.setShadowColor(UIColor.black, for: .highlighted)
        
        cardView2.cornerRadius = 10
        cardView2.setShadowElevation(ShadowElevation(rawValue: 6), for: .selected)
        cardView2.setShadowColor(UIColor.black, for: .highlighted)
        print("------------------")
        print(token)
        print("------------------")
        
        
    }
    
    @IBAction func verVideo(_ sender: Any) {
        /*
        if let path = Bundle.main.path(forResource: "https://www.youtube.com/watch?v=_WOwOVNEfzY", ofType: "mp4")
        {
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion:
                {
                    video.play()
            })
        }
 */
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    

}
    

    
   


