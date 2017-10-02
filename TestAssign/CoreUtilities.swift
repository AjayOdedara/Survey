//
//  CoreUtilities.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//

import Foundation
import UIKit


public typealias JSONDictionary = [String:AnyObject]
public typealias JSONArray = [AnyObject]



extension UIViewController {
    
    func showAlert(alertTitle:String, alertMessage:String, forSuccess success: Bool){
        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
}
class ViewControllerUtils {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x:0, y:0, width:80, height:80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    func hideActivityIndicator(uiView: UIView) {
        
        self.activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}


public class CoreUtilities {
    
    public class func JSONParseDictionary(jsonString: NSString) -> [String: AnyObject]? {
        if let data = jsonString.data(using: String.Encoding.utf8.rawValue) {
            if let dictionary = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))  as? [String: AnyObject] {
                return dictionary
            }
        }
        return nil
    }
    
    public class func JSONParseArray(jsonString: NSString) -> [AnyObject]? {
        if let data = jsonString.data(using: String.Encoding.utf8.rawValue) {
            if let array = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))  as? [AnyObject] {
                return array
            }
        }
        return nil
    }
    public class func removeNilFromDictionary(dict:[String: AnyObject]) -> [String: AnyObject] {
        var newDict = [String: AnyObject]()
        
        for key in dict.keys {
            let value:AnyObject = dict[key]!
            
            if let _ = value as? NSNull {
                // ignore it
            } else if let value = value as? [String: AnyObject] {
                newDict[key] = self.removeNilFromDictionary(dict: value) as AnyObject
            } else if let value = value as? [AnyObject] {
                newDict[key] = self.removeNilFromArray(array: value) as AnyObject
            } else {
                newDict[key] = value
            }
        }
        
        return newDict
    }
    
    public class func removeNilFromArray(array:[AnyObject]) -> [AnyObject] {
        var newArray = [AnyObject]()
        
        for value in array {
            
            if let _ = value as? NSNull {
                // ignore it
            } else if let value = value as? [String: AnyObject] {
                newArray.append( self.removeNilFromDictionary(dict: value) as AnyObject )
            } else if let value = value as? [AnyObject] {
                newArray.append( self.removeNilFromArray(array: value) as AnyObject )
            } else {
                newArray.append( value )
            }
        }
        
        return newArray
    }
    
}
