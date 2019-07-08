//
//  CategoryTableView.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 04/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class CategoryTableView: UITableViewController {
    
    //MARK: Properties
    
    var categories = [Category]()
    var selectedCategory:Category?
    let def = UserDefaults.standard
    
    //MARK: Methods
    private func loadCategories(){
        //cargamos las categorías con llamada get a la api
        //necesitamos enviar el token_access en los headers de la consulta
        let headers: HTTPHeaders = [
            "Authorization": def.string(forKey: "token")!
        ]
        
        Alamofire.request("http://genesis.test/api/categorias", headers: headers )
            .validate()
            .responseJSON{ response in
                guard response.error == nil else {
                    return
                }
                //tenemos las categorías, vamos a mostrarlas
                if let cats = response.result.value as! NSArray? {
                    for category in cats{
                        let data = category as! NSDictionary
                        self.categories.append(Category(id:data["id"] as! Int, code: data["code"] as! String, name: data["name"] as! String, description: data["description"] as! String))
                        
                    }
                    print(self.categories.count)
                }
                //refrescamos la tabla cuando tengamos todas las categorías
                self.tableView.reloadData()
        }
    }
    
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
        
        //identificador de la celda
        let cellIdentifier = "CategoryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell else{
            fatalError("la celda no es una instancia de CategoryTableViewCell")
        }
        
        //configuramos la celda a mostrar
        let category = categories[indexPath.row]
        cell.categoryNameLabel.text = category.name
        cell.categoryDescriptionArea.text = category.description
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //API DELETE request para borrar la categoría de la base de datos
            let headers: HTTPHeaders = [
                "Authorization": def.string(forKey: "token")!
            ]
            Alamofire.request("http://genesis.test/api/categorias/\(self.categories[indexPath.row].id)", method: .delete, headers: headers )
                .validate()
                .responseJSON{ response in
                    guard response.error == nil else {
                        //TODO  error
                        print(response.request)
                        return
                    }
            }
            // Borrar el row de la tabla
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    

     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if(segue.identifier == "ShowCategory"){
            guard let selectedCategoryCell = sender as? CategoryTableViewCell else {
                fatalError("sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCategoryCell) else {
                fatalError("error celda no existe")
            }
            
            let showCategoryVC = segue.destination as! CategoryShowView
            showCategoryVC.category =   categories[indexPath.row]
        }
     }

    
}
