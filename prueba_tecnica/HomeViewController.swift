//
//  HomeViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 04/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: properties
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        usernameLabel.text = Api.instance.userDefaults.string(forKey: "username")
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
       Api.instance.logout()
        performSegue(withIdentifier: "GoLogin", sender: self)
    }
}
