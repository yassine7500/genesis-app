//
//  Api.swift
//  prueba_tecnica
//
//  Created by Yassine El garras on 11/07/2019.
//  Copyright © 2019 Yassine El garras. All rights reserved.
//

import UIKit
import Alamofire

class Api: NSObject {
    
    //MARK: Properties
    
    static let instance = Api()
    let baseUrl = "http://genesis.test/api"
    let userDefaults = UserDefaults.standard
    var headers:HTTPHeaders? = nil
    
    //MARK: methods
    
    func alamoRequest(resource:String, parameters:Parameters? = nil, method:HTTPMethod, encoding:JSONEncoding? = nil, onSuccess success:@escaping (_ response:Any?)->(), onFail fail:@escaping ()->()){
        
        //comprobamos que la sesión actual tiene un token
        if userDefaults.string(forKey: "token") as String? != nil {
           self.headers = [
            "Authorization": userDefaults.string(forKey: "token")!
            ]
        }else{
            if resource != "auth/login" {
                fatalError("se está intentando acceder a un recurso sin tener token")
            }
        }
        
        if encoding != nil {
            //request al servidor
            Alamofire.request("\(baseUrl)/\(resource)", method: method, parameters: parameters, encoding: encoding!, headers: headers).validate().responseJSON{ response in
                
                //servidor ha respondido con un codigo de error
                guard response.error == nil else{
                    fail()
                    return
                }
                
                //
                success(response.result.value)
            }
        }else{
            //request al servidor
            Alamofire.request("\(baseUrl)/\(resource)", method: method, parameters: parameters, headers: headers).validate().responseJSON{ response in
                
                //servidor ha respondido con un codigo de error
                guard response.error == nil else{
                    fail()
                    return
                }
                
                //
                success(response.result.value)
            }
        }
    }
    
    
    
    public func logout()
    {
        userDefaults.setValue(false, forKey: "loggedIn")
    }
    
}
