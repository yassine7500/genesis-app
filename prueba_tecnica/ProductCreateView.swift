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

class ProductCreateView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK properties
    @IBOutlet weak var selectedCount: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var tarifasTableView: UITableView!
    @IBOutlet weak var codeInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var viewNavigationBar: UINavigationItem!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var codeErrorLabel: UILabel!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var imagesButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addTarifa: UIButton!
    
    var categories = [Category]()
    var tarifas = [Tarifa]()
    var tarifaToEdit:Tarifa?
    var product:Product?
    var selectedCategories = [Int]()
    let def = UserDefaults.standard
    var mode:String?
    
    
    override func viewDidLoad() {
        
        //datasource y delegate de l atabla de tarifas
        self.tarifasTableView.delegate = self
        self.tarifasTableView.dataSource = self
        
        //siempre cargamos una lista de las categorías publicadas
        loadAllCategories()
        
        switch mode {
        case "SHOW":
            modeShow()
        case "EDIT":
            modeEdite()
        case "CREATE":
            modeCreate()
        default:
            modeEdite()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if product != nil ||  product?.id != 0 {
            nameInput.text = product?.name
            codeInput.text = product?.code
            descriptionInput.text = product?.description
            
        }else{
            viewNavigationBar.title = "Crear Producto"
            mode = "CREATE"
        }
        
        selectedCount.text = "\(selectedCategories.count) seleccionadas"
    }
    
    //MARK: Actions
    
    @IBAction func showImagesPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowImages", sender: self)
    }
    
    @IBAction func addTarifaPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "CreateTarifa", sender: "Add")
    }
    
    
    //MARK UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tarifas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TarifasCell") as? TarifasTableViewCell else{
            fatalError("celda incorrecta");
        }
        
        cell.tarifa.text = String("\(self.tarifas[indexPath.row].tarifa)€")
        cell.desde.text = "del: \(self.tarifas[indexPath.row].desde)"
        cell.hasta.text = "a: \(self.tarifas[indexPath.row].hasta)"
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if self.mode == "EDIT" {
            Api.instance.alamoRequest(resource: "tarifas/\(tarifas[indexPath.row].id)", parameters: nil, method: .delete, onSuccess: { (response) in
                // Borrar el row de la tabla
                self.tarifas.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }) {
                print("error al borrar tarifa")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //editamos la tarifa pulsada
        if(saveButton.title == "Actualizar"){
            tarifaToEdit = tarifas[indexPath.row]
            performSegue(withIdentifier: "CreateTarifa", sender: "EditTarifa")
        }
    }
    
    //MARK: Seguecontrol
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //reutilizamos la vista de crear producto para editar
        //dependiendo del texto del boton, actualizaremos o crearemos uno nuevo
        if(identifier == "SavedProduct"){
            
            //si el sender es editar, nos quedamos en esta vista y mostramos mensaje success
            guard let button = sender as? UIBarButtonItem else{
                fatalError("esto no debe pasar");
            }
            
            //validacion
            let errorString = "Este campo es requerido";
            if(self.nameInput.text!.count < 1 || self.nameInput.text!.count > 255 || self.codeInput.text!.count < 1 || self.codeInput.text!.count > 255){
                self.nameErrorLabel.text = errorString
                self.nameErrorLabel.isHidden = false
                self.codeErrorLabel.text = errorString
                self.codeErrorLabel.isHidden = false
                return false;
            }
            
            var tarifasPreparadas = [[String:String]]()
            for tarifa in self.tarifas{
                tarifasPreparadas.append(["id":String(tarifa.id), "rate":String(tarifa.tarifa),"from":tarifa.desde,"to":tarifa.hasta])
            }
            let parameters: Parameters = [
                "code": self.codeInput.text!,
                "name":  self.nameInput.text!,
                "description": self.descriptionInput.text!,
                "categories": self.selectedCategories,
                "rates": tarifasPreparadas
            ]
            
            if(button.title == "Guardar"){
                //Post guardar nuevo producto
                Api.instance.alamoRequest(resource: "productos", parameters: parameters, method: .post, onSuccess: { (response) in
                    self.successLabel.text = "Producto Creado correctamente"
                    self.successLabel.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.performSegue(withIdentifier: "SavedProduct", sender: self)
                    })
                }, onFail: {print("error al crear producto")})
            }
            
            if(button.title == "Actualizar"){
                Api.instance.alamoRequest(resource: "productos/\(self.product!.id)", parameters: parameters, method: .put, encoding: JSONEncoding.default, onSuccess: { (response) in
                    self.successLabel.text = "Producto actualizado correctamente"
                    self.successLabel.isHidden = false
                    self.modeShow()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.performSegue(withIdentifier: "SavedProduct", sender: self)
                    })
                }) {
                    print("Error al actualizar el producto")
                }
            }
            
            if(button.title == "Editar"){
                modeEdite()
            }
            return false
        }
        return true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowCategories"){
            guard let pcVC = segue.destination as? ProductCategoryTableViewController else{
                fatalError("instancia incorrecta del segue")
            }
            
            pcVC.mode = mode
            pcVC.categories = categories
            pcVC.selectedCategories = selectedCategories
            pcVC.tarifas = tarifas
            //Si estamos en la vista de crear
            //pasaremos un product temporal a categorias
            //para guardar los datos introducidos
            if product == nil || product?.id == 0 {
                pcVC.product = Product(id: 0, code: codeInput.text!, name: nameInput.text!, description: descriptionInput.text!, thumbnail: nil)
            }else{
                pcVC.product = product
            }
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
            siVC.selectedCategories = self.selectedCategories
            siVC.mode = self.mode
            siVC.tarifas = self.tarifas
        }
        
        //preparando segue para crear/editar tarifa
        if segue.identifier == "CreateTarifa" {
            guard let t = segue.destination as? UINavigationController else{
                fatalError("el destino no es un UINavigationController")
            }
            guard let ctVC = t.topViewController as? TarifaCreateViewController else{
                fatalError("el top que sigue al nav no es un TarifaCreateViewController")
            }
            
            //Si la vista actual no tiene un producto (solo ocurre en el modo crear)
            //creamos un producto que sirve de placeholder para guardar los datos introducido hasta el momento
            if product == nil || product?.id == 0 {
                ctVC.product = Product(id: 0, code: codeInput.text!, name: nameInput.text!, description: descriptionInput.text!, thumbnail: nil)
            }else{
                ctVC.product = product
            }
            
            //dependiendo del sender, mostramos la vista de editar/crear tarifa
            if (sender as! String == "EditTarifa"){
                ctVC.tarifaMode = "Edit"
                ctVC.tarifa = tarifaToEdit
            }else{
                ctVC.tarifaMode = "CREATE"
            }
            ctVC.tarifas = tarifas
            ctVC.mode = mode
            ctVC.selectedCategories = selectedCategories
            
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
        
        //quitar boton para añadir tarifa
        addTarifa.isHidden = true
        addTarifa.isEnabled = false
        
        //cargamos tarifas del producto
        loadTarifas()
        loadProductCategories()
    }
    
    public func modeEdite(){
        mode = "EDIT"
        viewNavigationBar.title = "Editar Producto"
        saveButton.title = "Actualizar"
        nameInput.isEnabled = true
        codeInput.isEnabled = true
        descriptionInput.isEditable = true
        
        //mostrar boton para añadir tarifa
        addTarifa.isHidden = false
        addTarifa.isEnabled = true
        
        //cargamos tarifas del producto
        loadTarifas()
    }
    
    public func modeCreate(){
        mode = "CREATE"
        viewNavigationBar.title = "Crear nuevo producto"
        saveButton.title = "Guardar"
        nameInput.isEnabled = true
        codeInput.isEnabled = true
        descriptionInput.isEditable = true
        
        //mostrar boton para añadir tarifa
        addTarifa.isHidden = false
        addTarifa.isEnabled = true
    }
    
    //cargamos las tarifas de un producto en el modo editar y ver
    public func loadTarifas(){
        if tarifas.isEmpty && mode != "CREATE"{
            Api.instance.alamoRequest(resource: "productos/\(product!.id)/tarifas", method: .get, onSuccess: { (response) in
                if let tarifas = response as! NSArray? {
                    for tarifa in tarifas{
                        let data = tarifa as! NSDictionary
                        DispatchQueue.main.async {
                            self.tarifas.append(Tarifa(id:data["id"] as! Int, tarifa: data["rate"] as! Int, desde: data["from"] as! String, hasta: data["to"] as! String ))
                            self.tarifasTableView.reloadData()
                        }
                    }
                }
            }) {
                print("error al cargar las tarifas del producto")
            }
        }
    }
    
    private func loadAllCategories(){
        
        if categories.isEmpty {
            Api.instance.alamoRequest(resource: "categorias", method: .get, onSuccess: { (response) in
                if let cats = response as! NSArray? {
                    for category in cats{
                        let data = category as! NSDictionary
                        DispatchQueue.main.async {
                            self.categories.append(Category(id:data["id"] as! Int, code: data["code"] as! String, name: data["name"] as! String, description: data["description"] as! String))
                        }
                    }
                }
            }) {
                print("error al cargar todas las categorias")
            }
        }
        
    }
    
    private func loadProductCategories(){
        //obtenemos las categorias seleccionadas en caso del modo show o edit
        Api.instance.alamoRequest(resource: "productos/\(self.product!.id)/categorias", method: .get, onSuccess: { (response) in
            guard let categories = response as! NSArray? else {
                fatalError("las categorias recibidas no están del tipo NSArray")
            }
            for category in categories{
                let data = category as! NSDictionary
                DispatchQueue.main.async {
                    if self.selectedCategories.contains(data["id"] as! Int) == false{
                        self.selectedCategories.append(data["id"] as! Int)
                    }
                    self.selectedCount.text = "\(self.selectedCategories.count) seleccionados"
                }
            }
            
            
        }, onFail: {print("error al listar las categorías de un producto")})
    }
}


