//
//  CategoryTableView.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 04/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit

class CategoryTableView: UITableViewController {
    
    //MARK: Properties
    
    var categories = [Category]()
    var selectedCategory:Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else{
            fatalError("la celda no es una instancia de CategoryTableViewCell")
        }
        //configuramos la celda a mostrar
        let category = categories[indexPath.row]
        cell.categoryNameLabel.text = category.name
        cell.categoryDescriptionArea.text = category.description
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //API DELETE request para borrar la categoría de la base de datos
            
            Api.instance.alamoRequest(resource: "categorias/\(self.categories[indexPath.row].id)", parameters: nil, method: .delete, onSuccess: { (response) in
                
                //success: ahora borramos la categoría de la tabla
                self.categories.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                
            }) {
                print("error al borrar la categoria")
            }
        }
    }
    
    // MARK: - Navigation
    
    //pasamos los detalles de la categoría pulsada al siguiente ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ShowCategory"){
            guard let selectedCategoryCell = sender as? CategoryTableViewCell else {
                fatalError("sender es de una instancia diferente a la de CategoryTableViewCell: \(sender!)")
            }
            guard let indexPath = tableView.indexPath(for: selectedCategoryCell) else {
                fatalError("error celda no existe")
            }
            let showCategoryVC = segue.destination as! CategoryShowView
            showCategoryVC.category =   categories[indexPath.row]
        }
        
    }
    
    //MARK: Methods
    private func loadCategories(){
        //GET todas las categorias
        Api.instance.alamoRequest(resource: "categorias",parameters: nil, method: .get, onSuccess: { (response) in
            guard let categories = response as! NSArray? else {
                fatalError("categorias recibidas no estan en format array NSArray")
            }
            for category in categories{
                let data = category as! NSDictionary
                self.categories.append(Category(id:data["id"] as! Int, code: data["code"] as! String, name: data["name"] as! String, description: data["description"] as! String))
                
                //reload data después de recibir los datos
                self.tableView.reloadData()
            }
        }, onFail: {print("error al listar categorias")})
    }
    
    
}
