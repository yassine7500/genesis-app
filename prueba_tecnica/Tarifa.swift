//
//  Tarifa.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 08/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import Foundation

class Tarifa {
    
    var id:Int
    var tarifa:Int
    var desde:String
    var hasta:String
    
    init(id:Int, tarifa:Int, desde:String, hasta:String) {
        self.id = id
        self.tarifa = tarifa
        self.desde = desde
        self.hasta = hasta
    }
    
}
