//
//  ProductCategoryTableViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 06/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit

class ProductCategoryTableViewController: UITableViewController {

    var categories = [Category]()
    var tarifas = [Tarifa]()
    var selectedCategories = [Int]()
    var product:Product?
    var mode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCategoriesCell", for: indexPath) as? ProductCategoryTableViewCell else{
            fatalError("celda incorrecta")
        }
        // Configure the cell...
        cell.nameLabel.text = categories[indexPath.row].name
        //si la categoria a mostrar esta en la lista de las categorias seleccionadas

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cambiamos el estado de la celda a seleccionado
        
        for sc in selectedCategories{
            if(sc == categories[indexPath.row].id){
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //determinar las celdas seleccionadas
        self.selectedCategories.append(self.categories[indexPath.row].id)
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //quitamos las categorias que se han deseleccionado
        selectedCategories.removeAll(where: {$0 == categories[indexPath.row].id});
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GetCategories"){
            guard let createProductVC = segue.destination as? ProductCreateView else{
                fatalError("error instancia incompatible")
            }
            createProductVC.selectedCategories = self.selectedCategories;
            createProductVC.categories = self.categories
            createProductVC.product = self.product
            createProductVC.mode = self.mode
            createProductVC.tarifas = self.tarifas
        }
    }

    

}
