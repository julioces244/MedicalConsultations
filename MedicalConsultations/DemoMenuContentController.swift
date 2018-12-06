//
//  DemoMenuContentController.swift
//  MedicalConsultations
//
//  Created by Julio César on 6/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit


class DemoMenuContentController: UITableViewController, CariocaDataSource {

    // MARK: Configuration properties
    ///The original vertical position of the indicator, in %.
    var indicatorPosition: CGFloat = 50.0
    ///Can we move the menu out of the screen ?
    var isOffscreenAllowed: Bool = true
    ///The blur effect, optional
    var blurStyle: UIBlurEffectStyle? = .dark
    ///The boomerang type
    var boomerang: BoomerangType = .none
    ///The menu items displayed
    var menuItems: [CariocaMenuItem] = [
        CariocaMenuItem("Inicio", .emoji("🏠")),
        CariocaMenuItem("Perfil", .emoji("👤")),
        CariocaMenuItem("Buscar Doctor", .emoji("👨🏼‍💻")),
        CariocaMenuItem("Travel", .emoji("✈️")),
        CariocaMenuItem("Salir", .emoji("🚪"))
    ]
    ///This defines the height of each menu item
    func heightForRow() -> CGFloat { return 60.0 }
    
    // MARK: - menu data source
    //Create here your specific cell. Feel free to adjust the layout depending on the edge parameter
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath,
                   withEdge edge: UIRectEdge) -> UITableViewCell {
        let menuItem = menuItems[indexPath.row]
        //swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuItemCell
        //swiftlint:enable force_cast
        cell.titleLabel.text = menuItem.title.uppercased()
        cell.titleLabel.textAlignment = edge == .left ? .right : .left
        cell.iconLeftConstraint?.priority = edge == .left ? UILayoutPriority(50.0) : UILayoutPriority(100.0)
        cell.iconRightConstraint?.priority = edge == .right ? UILayoutPriority(50.0) : UILayoutPriority(100.0)
        cell.iconView.display(icon: menuItem.icon)
        return cell
    }
    

}

class MenuItemCell: UITableViewCell {
    
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconView: CariocaIconView!
    
    @IBOutlet weak var iconLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconRightConstraint: NSLayoutConstraint!
    
}


