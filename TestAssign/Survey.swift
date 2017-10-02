//
//  User.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import UIKit
@objc public class Surveys : NSObject {

    public var survey:[Survey]?

    public init(jsonDict:JSONArray) {
        super.init()
        
        var surveyData = [Survey]()
        for item in jsonDict {
            surveyData.append(Survey(jsonDict:item as! JSONDictionary))
        }
        survey = surveyData
 
    }

}
public class Survey : NSObject {
    
    public var title:String?
    public var descrit:String?
    public var image:String?
    
    public init(jsonDict:JSONDictionary) {
        super.init()
        
            title           = jsonDict["title"] as? String
            descrit         = jsonDict["description"] as? String
            image           = jsonDict["cover_image_url"] as? String
            if image != nil{
                image?.append("l")
            }
        
    }
    
}
