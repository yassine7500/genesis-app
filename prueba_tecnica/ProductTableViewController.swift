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
    
    override func viewDidLoad() {
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
            Api.instance.alamoRequest(resource: "productos/\(products[indexPath.row].id)", parameters: nil, method: .delete, onSuccess: { (response) in
                // Borrar el row de la tabla
                self.products.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }, onFail: {print("no se ha podido eliminar el producto")})
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "CreateProduct"){
            //activamos el modo crear nuevo producto
            let createProductVC = segue.destination as! ProductCreateView
            createProductVC.mode = "CREATE"
        }
    }
    
    //MARK:methods
    
    private func loadProducts(){
        //load products desde la api
        Api.instance.alamoRequest(resource: "productos", parameters: nil, method: .get, onSuccess: { (response) in
            guard let products = response as! NSArray? else{
                fatalError("Productos recibidos no son NSArray")
            }
            for product in products{
                let data = product as! NSDictionary
                self.products.append(Product(id:data["id"] as! Int, code: data["code"] as! String, name: data["name"] as! String, description: data["description"] as! String, thumbnail: data["thumbnail"] as? String))
                self.tableView.reloadData()
            }
        }, onFail: {print("Error al recibir productos")})
    }
    
    
}
