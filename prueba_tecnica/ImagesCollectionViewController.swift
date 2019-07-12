//
//  ImagesCollectionViewController.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 08/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire


private let reuseIdentifier = "ImageCell"


class ImagesCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: properties
    public var product:Product?
    public var productImages:[String] = []
    private let def = UserDefaults.standard
    @IBOutlet weak var imageView: UIImageView!
    private var images = [UIImage]()
    var selectedCategories = [Int]()
    var mode:String?
    var tarifas = [Tarifa]()
    var imagePicker = UIImagePickerController()
    
    
    
    private func alamoGetImages(){        
        if(mode != "CREATE"){
            let headers: HTTPHeaders = [
                "Authorization": def.string(forKey: "token")!
            ]
            Alamofire.request("http://genesis.test/api/productos/\(self.product!.id)/imagenes", method: .get, headers: headers )
                .validate()
                .responseJSON{ response in
                    guard response.error == nil else {
                        //TODO  error
                        return
                    }
                    if let images = response.result.value as! NSArray? {
                        for image in images{
                            let data = image as! NSDictionary
                            self.productImages.append("http://genesis.test/\(data["url"]!)")
                        }
                    }
                    
                    for pi in self.productImages {
                        do{
                            let url = URL(string: pi)!
                            let data = try Data(contentsOf: url)
                            self.images.append(UIImage(data: data)!)
                        }catch{
                            print(error)
                        }
                    }
                    self.collectionView.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alamoGetImages()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let productCreateView = segue.destination as? ProductCreateView else{
            fatalError("Error instancia")
        }
        productCreateView.product = self.product
        productCreateView.selectedCategories = selectedCategories
        productCreateView.mode = mode;
        productCreateView.tarifas = tarifas
    }
    
    //MARK: Actions
    @IBAction func addImagePressed(_ sender: Any) {
        //mostramos el imagepicker para que el usuario pueda elegir
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        images.append(image)
        picker.dismiss(animated: true, completion: nil)
        
        print("images\(images)")
        collectionView.reloadData()
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else{
            fatalError("la clase de la celda no es correcta")
        }
        
        
        
        cell.productImage.image = images[indexPath.row] 
        cell.contentView.addSubview(cell.productImage)
        
        /* Configure the cell
        do {
            let url = URL(string: productImages[indexPath.row])!
            let data = try Data(contentsOf: url)
            cell.productImage.image = UIImage(data: data)
        }
        catch{
            print(error)
        }*/
    
        return cell
    }
}
