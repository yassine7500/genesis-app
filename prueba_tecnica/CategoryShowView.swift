//
//  CategoryShowView.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 06/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class CategoryShowView: UIViewController {
    
    //MARK: Properties
    var category:Category!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var codeInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    let def = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        codeInput.text = category.code
        nameInput.text = category.name
        descriptionInput.text = category.description
    }
    
    
    //MARK: Actions
    @IBAction func editarPressed(_ sender: UIBarButtonItem) {
        
        //realizamos acciones dependiendo del texto del boton
        if (editButton.title == "Editar"){
            //activamos la edición de los fields
            codeInput.isEnabled = true
            nameInput.isEnabled = true
            descriptionInput.isEditable = true
            editButton.title = "Guardar"
            
        }else{
            //guardamos los cambios en la BD
            let headers: HTTPHeaders = [
                "Authorization": def.string(forKey: "token")!
            ]
            
            let parameters: Parameters = [
                "code": codeInput.text!,
                "name": nameInput.text!,
                "description": descriptionInput.text!
            ]
            Alamofire.request("http://genesis.test/api/categorias/\(category.id)", method: .put, parameters: parameters, headers: headers )
                .validate()
                .responseJSON{ response in
                    guard response.error == nil else {
                        //TODO  error
                        print("error en la request: \(response.error!)")
                        return
                    }
                    //mostramos mensaje de success
                    self.successLabel.isHidden = false
                    self.successLabel.text = "Categoría actualizada correctamente"
            }
            //desactivamos el modo editar
            codeInput.isEnabled = false
            nameInput.isEnabled = false
            descriptionInput.isEditable = false
            editButton.title = "Editar"
        }
        
        
        
    }
    
}
