//
//  CategoryCreateViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 05/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class CategoryCreateViewController: UIViewController{
    
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
       super.viewDidLoad()
    }
    
    func validate(){
        let errorString = "Este campo es requerido";
        if(self.nameInput.text!.count < 1 || self.nameInput.text!.count > 255 || self.codeInput.text!.count < 1 || self.codeInput.text!.count > 255){
            self.nameErrorLabel.text = errorString
            self.nameErrorLabel.isHidden = false
            self.codeErrorLabel.text = errorString
            self.codeErrorLabel.isHidden = false
        }
    }
    
    
    //MARK: segue
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //comprobamos los datos
        validate()
        
        let parameters: Parameters = [
             "user_id": self.def.integer(forKey: "userID"),
             "code": self.codeInput.text!,
             "name":  self.nameInput.text!,
             "description": self.descriptionInput.text!
        ]
        
        Api.instance.alamoRequest(resource: "categorias", parameters: parameters, method: .post, onSuccess: { (data) in
            self.performSegue(withIdentifier: "SaveCategory", sender: self)
        }, onFail: {
            print("error del servidor")
        })
        
        return false;
    }
    
}
