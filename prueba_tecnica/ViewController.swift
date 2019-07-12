//
//  ViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 04/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    //MARK: propiedades
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        //comprobamos si el usuario se ha logueado anteriormente
        if Api.instance.userDefaults.bool(forKey: "loggedIn") {
            performSegue(withIdentifier: "GoHome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: acciones
    
    @IBAction func loginPressed(_ sender: Any) {
        let parameters: Parameters = [
            "username": usernameInput.text!,
            "password": passwordInput.text!
        ]
        
        Api.instance.alamoRequest(resource: "auth/login", parameters: parameters, method: .post, onSuccess: { (response) in
            
            guard let data = response as! NSDictionary? else{
                fatalError("datos  recibidos en formato diferente a NSDictionary")
            }
            
            //Set estado logueado en true y guardar info en UserDefaults
            Api.instance.userDefaults.setValue(true, forKey: "loggedIn")
            Api.instance.userDefaults.setValue(data["username"], forKey: "username")
            Api.instance.userDefaults.setValue("\(data["token_type"]!) \(data["access_token"]!)", forKey: "token")
            Api.instance.userDefaults.setValue(data["id"], forKey: "userID")
            self.performSegue(withIdentifier: "GoHome", sender: self)
            
            
        }, onFail: {
            self.errorLabel.text = "Login no válido"
            self.errorLabel.isHidden = false
        })
    }
    
    
    
}

