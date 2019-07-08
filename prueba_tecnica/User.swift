//
//  User.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 05/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import os.log

class User: NSObject, NSCoding {
    
    var userID:Int
    var username:String
    var token:String
    
    struct PropertyKey {
        static let userID = "userID"
        static let username = "username"
        static let token = "token"
    }
    
    //MARK: Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    //MARK: initialization
    
    init?(userID:Int, username:String, token:String) {
        self.userID = userID
        self.username = username
        self.token = token
    }
    
    //MRAK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userID, forKey: PropertyKey.userID)
        aCoder.encode(username, forKey: PropertyKey.username)
        aCoder.encode(token, forKey: PropertyKey.token)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        //descodificamos los datos de la calase
        guard let userID = aDecoder.decodeObject(forKey: PropertyKey.userID) as? Int else{
            os_log("no se ha podido decodificar el id de usuario", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let username = aDecoder.decodeObject(forKey: PropertyKey.username) as? String else{
            os_log("no se ha podido decodificar el nombre de usuario", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let token = aDecoder.decodeObject(forKey: PropertyKey.token) as? String else{
            os_log("no se ha podido decodificar el token", log: OSLog.default, type: .debug)
            return nil
        }
        
        //llamamos al init
        self.init(userID: userID, username: username, token: token)
    }
    
}
