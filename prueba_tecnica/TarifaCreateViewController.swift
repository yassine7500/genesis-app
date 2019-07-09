//
//  TarifaCreateViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 09/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class TarifaCreateViewController: UIViewController {

    //MARK:properties
    @IBOutlet weak var tarifaInput: UITextField!
    @IBOutlet weak var desdeDate: UIDatePicker!
    @IBOutlet weak var hastaDate: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var tarifa:Tarifa?
    var tarifas = [Tarifa]()
    var product:Product?
    var selectedCategories = [Int]()
    var mode:String?
    var tarifaMode:String?
    let def = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(tarifaMode == "Edit"){
            let format = DateFormatter();
            format.dateFormat = "yyyy/MM/dd"
            
            desdeDate.date = format.date(from: tarifa!.desde)!
            hastaDate.date = format.date(from: tarifa!.hasta)!
            tarifaInput.text = String(tarifa!.tarifa)
        }
    }
    

    //MARK:Actions
    
    //comprobamos los datos y creamos/editamos tarifa
    @IBAction func savePressed(_ sender: Any) {
        
        if(validate()){

            //si el id del producto es 0 significa que no hemos guardado el producto todavía
            //pasaremos los datos de la tarifa y la guardaremos al guardar el producto

            if(mode == "CREATE" || mode == "EDIT" && tarifaMode != "Edit"){
                let format = DateFormatter();
                format.dateFormat = "yyyy/MM/dd"
                
                let desde = format.string(from: desdeDate.date)
                let hasta = format.string(from: hastaDate.date)
                
                
                tarifas.append(Tarifa(id: 0, tarifa: Int(tarifaInput.text!)!, desde: desde, hasta: hasta))
                
                performSegue(withIdentifier: "GoBack", sender: self)
            }
            
            //si estamos en el modo editar tarifa
            //la podemos actualizar aquí mismo
            if tarifa != nil {
                
                let format = DateFormatter();
                format.dateFormat = "yyyy/MM/dd"
                
                let headers: HTTPHeaders = [
                    "Authorization": def.string(forKey: "token")!
                ]
                
                let parameters:Parameters = [
                    "from" : format.string(from: desdeDate.date),
                    "to" : format.string(from: hastaDate.date),
                    "rate" : tarifaInput.text!
                ]
                
                self.tarifas.first(where: {$0.id == self.tarifa?.id})?.tarifa = Int(tarifaInput.text as! String)!
                self.tarifas.first(where: {$0.id == self.tarifa?.id})?.desde = format.string(from: desdeDate.date)
                self.tarifas.first(where: {$0.id == self.tarifa?.id})?.hasta = format.string(from: desdeDate.date)
                
                //PUT actualizar producto en la api
                Alamofire.request("http://genesis.test/api/tarifas/\(self.tarifa!.id)", method: .put, parameters: parameters, headers: headers )
                    .validate()
                    .responseJSON{ response in
                        guard response.error == nil else {
                            //TODO  error
                            return
                        }
                        //actualizado sin errores, mostramos success y cambiamos el estado de la vista
                        self.performSegue(withIdentifier: "GoBack", sender: "UpdateTarifa")
                        
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoBack"){
            guard let cpVC = segue.destination as? ProductCreateView else{
                fatalError("error instancia")
            }
            cpVC.mode = mode
            cpVC.product = product
            cpVC.selectedCategories = selectedCategories
            cpVC.tarifas = tarifas
            
        }
    }
    
    private func validate () -> Bool{
        if tarifaInput.text == "" {
            //TODO hay que mostrar un mensaje de error al user
            print("Datos incompletos")
            return false;
        }
        return true;
    }
    

}
