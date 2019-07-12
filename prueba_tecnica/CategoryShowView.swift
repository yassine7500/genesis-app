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
            let parameters: Parameters = [
                "code": codeInput.text!,
                "name": nameInput.text!,
                "description": descriptionInput.text!
            ]
            
            Api.instance.alamoRequest(resource: "categorias/\(category.id)", parameters: parameters, method: .put, onSuccess: { (response) in
                self.successLabel.isHidden = false
                self.successLabel.text = "Categoría actualizada correctamente"
            }, onFail: {print("Error al actualizar categoría")})
            
            //desactivamos el modo editar
            codeInput.isEnabled = false
            nameInput.isEnabled = false
            descriptionInput.isEditable = false
            editButton.title = "Editar"
        }
    }
    
}
