//
//  ProductTableViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 06/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class ProductTableViewController: UITableViewController {
    
    //MARK: properties
    var products = [Product]()
    var categories = [Category]()
    let def = UserDefaults.standard
    
    //MARK:methods
    
    private func loadProducts(){
        //load products desde la api
        let headers: HTTPHeaders = [
            "Authorization": def.string(forKey: "token")!
        ]
        Alamofire.request("http://genesis.test/api/productos", headers: headers )
            .validate()
            .responseJSON{ response in
                guard response.error == nil else {
                    print(response.error)
                    return
                }
                if let products = response.result.value as! NSArray? {
                    for product in products{
                        let data = product as! NSDictionary
                        self.products.append(Product(id:data["id"] as! Int, code: data["code"] as! String, name: data["name"] as! String, description: data["description"] as! String, thumbnail: data["thumbnail"] as? String))
                        //refrescamos la tabla cuando tengamos los productos
                        self.tableView.reloadData()
                        print(products.count)
                    }
                }
        }
    }
    
    override func viewDidLoad() {
        print("productos didload")
        super.viewDidLoad()
        loadProducts()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else{
            fatalError("Estancia incorrecta de celda")
        }
        let product = products[indexPath.row]
        cell.nameLabel.text = product.name
        cell.codeLabel.text = product.code
        if product.thumbnail != nil {
            do {
                let url = URL(string: "http://genesis.test/\(product.thumbnail!)")!
                let data = try Data(contentsOf: url)
                cell.productThumbnail.image = UIImage(data: data)
            }
            catch{
                print(error)
            }
        }
        //devolvemos la celda ya populada con datos
        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createProductVC = storyboard?.instantiateViewController(withIdentifier: "ProductCreateView") as! ProductCreateView
        createProductVC.product = products[indexPath.row]
        createProductVC.mode = "SHOW"
        present(createProductVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //API DELETE request para borrar la categoría de la base de datos
            let headers: HTTPHeaders = [
                "Authorization": def.string(forKey: "token")!
            ]
            Alamofire.request("http://genesis.test/api/productos/\(self.products[indexPath.row].id)", method: .delete, headers: headers )
                .validate()
                .responseJSON{ response in
                    guard response.error == nil else {
                        //TODO  error
                        print(response.request)
                        return
                    }
            }
            // Borrar el row de la tabla
            self.products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "CreateProduct"){
            //activamos el modo crear nuevo producto
            let createProductVC = segue.destination as! ProductCreateView
            createProductVC.mode = "CREATE"
        }
        
        /*if(segue.identifier == "CreateProduct" || segue.identifier == "ShowProduct"){
            let headers: HTTPHeaders = [
                "Authorization": def.string(forKey: "token")!
            ]
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
                            self.categories.append(Category(id:data["id"] as! Int, code: data["code"] as! String, name: data["name"] as! String, description: data["description"] as! String))
                        }
                    }
                    
                    //pasamos las categorias a la vista de crear/ver product
                    let createProductVC = segue.destination as! ProductCreateView
                    createProductVC.categories =   self.categories
                    
                    //si estamos intentando ver el producto,
                    //pasaremos el producto, y sus categorias seleccionadas
                    if(segue.identifier == "ShowProduct"){
                        guard let cell = sender as? UITableViewCell else{
                            print("no se puede acceder porque el sender es diferente a celda")
                            return
                        }
                        guard let indexPath = self.tableView.indexPath(for: cell) else {
                            fatalError("cleda incorrecta")
                        }
                        //id del product seleccionado
                        createProductVC.product = self.products[indexPath.row]
                        
                        //las categorias seleccionadas del producto
                        Alamofire.request("http://genesis.test/api/productos/\(self.products[indexPath.row].id)/categorias", method: .get, headers: headers )
                            .validate()
                            .responseJSON{ response in
                                guard response.error == nil else {
                                    //TODO  error
                                    return
                                }
                                if let cats = response.result.value as! NSArray? {
                                    var selected = [Int]()
                                    for category in cats{
                                        let data = category as! NSDictionary
                                        selected.append(data["id"] as! Int)
                                    }
                                    createProductVC.selectedCategories = selected
                                    createProductVC.selectedCount.text = "\(selected.count) seleccionados"
                                    createProductVC.modeShow()
                                }
                        }
                    }
                    
            }
        }*/
    }
    
    
}
