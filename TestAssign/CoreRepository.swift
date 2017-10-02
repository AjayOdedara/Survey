//
//  CoreRepository.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import Foundation

open class CoreRepository : Repository {

    override init(apiRoot:String) {
        super.init(apiRoot: apiRoot)
    }
    
    lazy private var api:CoreApiAccess = {
        let theApi = CoreApiAccess(apiRoot:Constant.apiRoot)
        return theApi
    }()
    
    // GET Syrveys
    open func getSurveys(onCompletion:@escaping ((Surveys)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getSurveys(success: { response -> Void in
            let user = Surveys(jsonDict: response)
            onCompletion(user)
            }, failure: {
                (error) -> Void in
                onError?(error)
        });
    }
}
