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
private let sectionInsets = UIEdgeInsets(top: 50.0,
                                         left: 20.0,
                                         bottom: 50.0,
                                         right: 20.0)

class ImagesCollectionViewController: UICollectionViewController {

    public var product:Product?
    public var productImages:[String] = []
    private let def = UserDefaults.standard
    private var images:[UIImage]?
    
    private func alamoGetImages(){
        
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
                if let cats = response.result.value as! NSArray? {
                    for category in cats{
                        let data = category as! NSDictionary
                        self.productImages.append("http://genesis.test/\(data["url"]!)")
                    }
                }
                self.collectionView.reloadData()
                
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alamoGetImages()

        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else{
            fatalError("la clase de la celda no es correcta")
        }
        
        // Configure the cell
        do {
            let url = URL(string: productImages[indexPath.row])!
            let data = try Data(contentsOf: url)
            cell.productImage.image = UIImage(data: data)
        }
        catch{
            print(error)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
