//
//  Repository.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import Foundation

open class Repository : NSObject {
    
    public let apiRoot:String
    
    public init(apiRoot:String) {
        self.apiRoot = apiRoot
    }
    
    public var surveys:Surveys?{
        didSet {

            print("User set ")
        }
    }
    


}
