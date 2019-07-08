//
//  HomeViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 04/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    //MARK: propieties
    var username: String = "user"
    @IBOutlet weak var usernameLabel: UILabel!
    let def = UserDefaults.standard
    
    override func viewDidLoad() {
        usernameLabel.text = def.string(forKey: "username")
    }
    
    //MARK: Actions
    @IBAction func categoriesPressed(_ sender: UIButton) {
        
        //las categorías se cargarán en la tabla
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        //limipamos las variables usuario guardadas
        self.def.setValue(false, forKey: "loggedIn")
        //volvemos a la vista de login
        performSegue(withIdentifier: "GoLogin", sender: self)
    }
    
    
}
