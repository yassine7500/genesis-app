//
//  TarifaCreateViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 09/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK:Actions
    @IBAction func savePressed(_ sender: Any) {
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
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
    

}
