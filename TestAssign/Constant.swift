//
//  Constants.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import Foundation

struct Constant {

    public static let apiRoot = "https://nimbl3-survey-api.herokuapp.com/"
    struct Config {
        
            static let clientId         = "78bcdc7c-78bd-41b9-bddc-32d836b237f3"
            static let clientSecret     = "771a4b12-6d1c-46e5-833d-61e9b42fee0e"
        
            static let username         = "carlos@nimbl3.com"
            static let password         = "antikera"
        
            static let tokenUrl         = "https://nimbl3-survey-api.herokuapp.com/oauth/token"
    }
    
    /* Application Usage */
    static let kErrorTitile                 = "Error Occurred"
    static let ApiErrorDomain               = "com.nimbl3.core.error"
    
}

