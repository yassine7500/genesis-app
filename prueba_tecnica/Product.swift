//
//  Product.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 06/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit

class Product {
    
    //MARK: properties
    var id:Int
    var code:String
    var name:String
    var description:String
    var thumbnail:String?
    
    init(id:Int, code:String, name:String, description:String, thumbnail:String?) {
        self.id = id
        self.code = code
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
    }
}
