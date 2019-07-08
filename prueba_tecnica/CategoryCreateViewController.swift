//
//  CategoryCreateViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 05/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class CategoryCreateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: properties
    @IBOutlet weak var codeInput: UITextField!
    @IBOutlet weak var codeErrorLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var descriptionErrorLabel: UILabel!
    
    var code:String?
    let def = UserDefaults.standard
    
    override func viewDidLoad() {
        codeInput.delegate = self
        nameInput.delegate = self
        descriptionInput.delegate = self
    }
    
    //MARK: TextInputDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //escoder teclado
        textField.resignFirstResponder()
        return true;
    }
    
    
    //MARK: segue
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //comprobamos los datos
        if(identifier == "SaveCategory"){
            let errorString = "Este campo es requerido";
            if(self.nameInput.text!.count < 1 || self.nameInput.text!.count > 255 || self.codeInput.text!.count < 1 || self.codeInput.text!.count > 255){
                self.nameErrorLabel.text = errorString
                self.nameErrorLabel.isHidden = false
                self.codeErrorLabel.text = errorString
                self.codeErrorLabel.isHidden = false
                return false;
            }
        }
        
        let headers: HTTPHeaders = [
            "Authorization": def.string(forKey: "token")!
        ]
        
        let parameters: Parameters = [
             "user_id": self.def.integer(forKey: "userID"),
             "code": self.codeInput.text!,
             "name":  self.nameInput.text!,
             "description": self.descriptionInput.text!
        ]
        
        //todo ok, vamos a guardar la categoría en la BD
        Alamofire.request("http://genesis.test/api/categorias", method: .post, parameters: parameters, headers: headers )
            .validate()
            .responseJSON{ response in
                guard response.error == nil else {
                    //TODO  error
                    print(response.error!)
                    return
                }
                //vamos a la siguiente vista
                self.performSegue(withIdentifier: "SaveCategory", sender: self)
        }
        return false;
    }
    
}
