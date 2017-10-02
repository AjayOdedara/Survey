//
//  CoreApiAccess.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import Foundation
import p2_OAuth2
import CoreFoundation

public final class CoreApiAccess: ApiAccess {
    
    
    internal func getSurveys(success: @escaping (JSONArray) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "surveys.json?page=1&per_page=10")!
        let request = oauth2.request(forURL: url as URL)
        
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromArray(array: dict)
                success(dict)
            } else {
                failure?(NSError(domain: Constant.ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }

}
