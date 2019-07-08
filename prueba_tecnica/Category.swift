//
//  Category.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 04/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit

class Category {
    
    //MARK: Properties
    
    var id:Int
    var code:String
    var name:String
    var description:String
    
    //MARK: Initialization
    init(id:Int, code:String, name:String, description:String) {
        self.id = id
        self.code = code
        self.name = name
        self.description = description
    }
}
