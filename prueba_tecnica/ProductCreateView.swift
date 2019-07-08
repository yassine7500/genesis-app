//
//  ProductCreateView.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 06/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProductCreateView: UIViewController {
    
    
    //MARK properties
    @IBOutlet weak var selectedCount: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var codeInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var viewNavigationBar: UINavigationItem!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var codeErrorLabel: UILabel!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var imagesButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var categories = [Category]()
    var product:Product?
    var selectedCategories = [Int]()
    let def = UserDefaults.standard
    var mode:String?
    
    override func viewDidLoad() {
        let headers: HTTPHeaders = [
            "Authorization": def.string(forKey: "token")!
        ]
        //hacemos un request para obtener todas las categorias una vez
        if categories.isEmpty {
            Alamofire.request("http://genesis.test/api/categorias", method: .get, headers: headers )
                .validate()
                .responseJSON{ response in
                    guard response.error == nil else {
                        //TODO  error
                        print("error request: \(response.error!)")
                        return
                    }
                    if let cats = response.result.value as! NSArray? {
                        for category in cats{
                            let data = category as! NSDictionary
                            DispatchQueue.main.async {
                                self.categories.append(Category(id:data["id"] as! Int, code: data["code"] as! String, name: data["name"] as! String, description: data["description"] as! String))
                            }
                        }
                    }
            }
        }
        
        switch mode {
        case "SHOW":
            modeShow(); break
        case "EDIT":
            modeEdite(); break;
        case "CREATE":
            modeCreate(); break;
        default:
            modeEdite(); break;
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if product != nil {
            //si tenemos un producto, significa que estamos mostrando/editando
            nameInput.text = product?.name
            codeInput.text = product?.code
            descriptionInput.text = product?.description
            
        }else{
            viewNavigationBar.title = "Crear Producto"
            mode = "CREATE"
        }
        
        //mostramos numero de categorias seleccionadas
        selectedCount.text = "\(selectedCategories.count) seleccionadas"
    }
    
    //MARK: Actions
    
    @IBAction func showImagesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowImages", sender: self)
    }
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        //cambiamos el titulo dependiendo del modo de vista
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //reutilizamos la vista de crear producto para editar
        //dependiendo del texto del boton, actualizaremos o crearemos uno nuevo
        if(identifier == "SavedProduct"){
            
            //si el sender es editar, nos quedamos en esta vista y mostramos mensaje success
            guard let button = sender as? UIBarButtonItem else{
                fatalError("esto no debe pasar");
            }
            
            let errorString = "Este campo es requerido";
            if(self.nameInput.text!.count < 1 || self.nameInput.text!.count > 255 || self.codeInput.text!.count < 1 || self.codeInput.text!.count > 255){
                self.nameErrorLabel.text = errorString
                self.nameErrorLabel.isHidden = false
                self.codeErrorLabel.text = errorString
                self.codeErrorLabel.isHidden = false
                return false;
            }
            
            let headers: HTTPHeaders = [
                "Authorization": def.string(forKey: "token")!
            ]
            
            let parameters: Parameters = [
                "code": self.codeInput.text!,
                "name":  self.nameInput.text!,
                "description": self.descriptionInput.text!,
                "categories": self.selectedCategories
            ]
            
            if(button.title == "Guardar"){
                
                print("Guardando producto")
                //Post guardar nuevo producto
                Alamofire.request("http://genesis.test/api/productos", method: .post, parameters: parameters, headers: headers )
                    .validate()
                    .responseJSON{ response in
                        guard response.error == nil else {
                            //TODO  error
                            return
                        }
                        //actualizado sin errores, mostramos success y cambiamos el estado de la vista
                        self.successLabel.text = "Producto Creado correctamente"
                        self.successLabel.isHidden = false
                        self.performSegue(withIdentifier: "SavedProduct", sender: self)
                }
                return false
            }
            
            if(button.title == "Actualizar"){
                print("Actualizando producto")
                print(parameters)
                //PUT actualizar producto en la api
                Alamofire.request("http://genesis.test/api/productos/\(self.product!.id)", method: .put, parameters: parameters, headers: headers )
                    .validate()
                    .responseJSON{ response in
                        guard response.error == nil else {
                            //TODO  error
                            return
                        }
                        //actualizado sin errores, mostramos success y cambiamos el estado de la vista
                        self.successLabel.text = "Producto actualizado correctamente"
                        self.successLabel.isHidden = false
                        self.modeShow()
                }
                return false;
            }
        
            if(button.title == "Editar"){
                modeEdite()
                return false
            }
            
            /*let headers: HTTPHeaders = [
                "Authorization": def.string(forKey: "token")!
            ]
            
            let parameters: Parameters = [
                "code": self.codeInput.text!,
                "name":  self.nameInput.text!,
                "description": self.descriptionInput.text!,
                "categories": self.selectedCategories
            ]
            
            //todo ok, vamos a guardar la categoría en la BD
            Alamofire.request("http://genesis.test/api/productos", method: .post, parameters: parameters, headers: headers )
                .validate()
                .responseJSON{ response in
                    guard response.error == nil else {
                        //TODO  error
                        print(response.error!)
                        return
                    }       
            }*/
        }
        //vamos a la lista de productos creados
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowCategories"){
            guard let pcVC = segue.destination as? ProductCategoryTableViewController else{
                fatalError("instancia incorrecta del segue")
            }
            pcVC.categories = categories
            pcVC.selectedCategories = selectedCategories
            
            //Si estamos en la vista de crear
            //pasaremos un product temporal a categorias
            //para guardar los datos introducidos
            if product == nil || product?.id == 0 {
                pcVC.product = Product(id: 0, code: codeInput.text!, name: nameInput.text!, description: descriptionInput.text!, thumbnail: nil)
            }else{
                pcVC.product = product
            }
            pcVC.mode = mode
        }
        
        if segue.identifier == "ShowImages" {
            
            guard let nVC = segue.destination as? UINavigationController else{
                fatalError("error instancia")
            }
            //pasamos el producto actual
            guard let siVC =  nVC.topViewController as? ImagesCollectionViewController else{
                fatalError("boton pulsado pero la instancia del objetivo no corresponde")
            }
            siVC.product = product
        }
    }
    
    public func modeShow(){
        mode="SHOW"
        //cambiamos el estado de los componentes al modo mostrar
        viewNavigationBar.title = "Detalles Producto"
        saveButton.title = "Editar"
        nameInput.isEnabled = false
        codeInput.isEnabled = false
        descriptionInput.isEditable = false
        
        //obtenemos las categorias seleccionadas en caso del modo show o edit
        let headers: HTTPHeaders = [
            "Authorization": def.string(forKey: "token")!
        ]
        Alamofire.request("http://genesis.test/api/productos/\(self.product!.id)/categorias", method: .get, headers: headers )
            .validate()
            .responseJSON{ response in
                guard response.error == nil else {
                    //TODO  error
                    return
                }
                if let cats = response.result.value as! NSArray? {
                    for category in cats{
                        let data = category as! NSDictionary
                        DispatchQueue.main.async {
                            if self.selectedCategories.contains(data["id"] as! Int) == false{
                                self.selectedCategories.append(data["id"] as! Int)
                            }
                            self.selectedCount.text = "\(self.selectedCategories.count) seleccionados"
                        }
                    }
                }
        }
    }
    
    public func modeEdite(){
        mode = "EDIT"
        viewNavigationBar.title = "Editar Producto"
        saveButton.title = "Actualizar"
        nameInput.isEnabled = true
        codeInput.isEnabled = true
        descriptionInput.isEditable = true
    }
    
    public func modeCreate(){
        mode = "CREATE"
        viewNavigationBar.title = "Crear nuevo producto"
        saveButton.title = "Guardar"
        nameInput.isEnabled = true
        codeInput.isEnabled = true
        descriptionInput.isEditable = true
    }
    
    
}
