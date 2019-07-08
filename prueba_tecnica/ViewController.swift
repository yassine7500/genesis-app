//
//  ViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 04/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire
import os.log

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: propiedades
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var username:String = ""
    var password:String = ""
    let def = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        //comprobamos si el usuario se ha logueado anteriormente
        print(self.def.bool(forKey: "loggedIn"))
        if self.def.bool(forKey: "loggedIn") {
            self.username = self.def.string(forKey: "username")!
            performSegue(withIdentifier: "GoHome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // comprobamos el login del usuario
        
        //bind de los inputs
        usernameInput.delegate = self
        passwordInput.delegate = self
    }
    
    //MARK: acciones
    @IBAction func loginPressed(_ sender: Any) {
        //TODO validamos input
        let parameters: Parameters = [
            "username": self.username,
            "password": self.password
        ]
        
        print(parameters)
        //post para loguear
        Alamofire.request("http://genesis.test/api/auth/login", method: .post, parameters: parameters )
            .validate()
            .responseJSON{ response in
                guard response.error == nil else {
                    // si los datos son incorrectos, mostramos un error
                    self.errorLabel.text = "Datos inválidos"
                    self.errorLabel.isHidden = false
                    print("error al loguear")
                    return
                }
                if let json = response.result.value as! NSDictionary? {
                    let token = "\(json["token_type"] as! String) \(json["access_token"] as! String)"
                    let username = json["username"] as! String
                    let userID = json["id"] as! Int
                    //let user = User(userID: userID, username: username, token: token);
                
                    //guardamos el estado de login a true
                    self.def.setValue(userID, forKey: "userID")
                    self.def.setValue(true, forKey: "loggedIn")
                    self.def.setValue(username, forKey: "username")
                    self.def.setValue(token, forKey: "token")
                }
                
                //si el login es valido:
                //creamos objeto usuario
                
                
                //vamos a la siguiente vista
                print("correcto")
                self.performSegue(withIdentifier: "GoHome", sender: self)
        }
    }
    
    //MARK: Delegate inputs de texto
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //desactivamos teclado
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //guardamos los datos en variables
        switch textField.accessibilityIdentifier {
        case "username":
            self.username = textField.text!
        case "password":
            self.password = textField.text!
        default:
            break
        }
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pasamos el nombre de usuario a la vista Home
        if(segue.identifier == "GoHome"){
            let homeVC = segue.destination as! HomeViewController
            homeVC.username = self.username
        }
    }
}

