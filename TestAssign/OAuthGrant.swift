
//
//  ConnectMobileOAuthGran.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import Foundation
import p2_OAuth2


public var _oauth2:OAuth2?

public var oauth2:OAuth2{
    get{
        if _oauth2 == nil{
            print("OAuth2 must have value")
            abort()
        }
            return _oauth2!
        }
    set{
        _oauth2 = newValue;
    }
}



public func MobileOAuthPasswordGrant(userName: String, password: String) -> OAuth2 {

    let grant = OAuth2PasswordGrant(settings:[
        "client_id": Constant.Config.clientId,
        "client_secret": Constant.Config.clientSecret,
        "authorize_uri": Constant.Config.tokenUrl,
        "token_uri": Constant.Config.tokenUrl,
        "verbose": true,
        ]as OAuth2JSON)
    
    grant.username = userName
    grant.password = password
    
    return grant
    
}

