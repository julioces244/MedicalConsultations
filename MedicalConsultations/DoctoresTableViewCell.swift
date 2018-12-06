//
//  DoctoresTableViewCell.swift
//  MedicalConsultations
//
//  Created by Julio César on 26/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit

class DoctoresTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pictureImage: UIImageView!
    
    
    @IBOutlet weak var nombreLabel: UILabel!
    
    
    @IBOutlet weak var apellidoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
