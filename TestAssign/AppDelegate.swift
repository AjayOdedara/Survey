//
//  AppDelegate.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var indicator = ViewControllerUtils()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        blankView()
        oauth2 = MobileOAuthPasswordGrant(userName: Constant.Config.username, password: Constant.Config.password)
        indicator.showActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
        oauth2.authorize() { authParameters, error in
            if let params = authParameters {
                print("Authorized! Access token is in `oauth2.accessToken`")
                print("Authorized! Additional parameters: \(params)")
                self.setWindow()
            }
            else {
                
                self.window?.rootViewController?.showAlert(alertTitle: Constant.kErrorTitile, alertMessage: (error?.localizedDescription)!, forSuccess: true)
            }
        }
        return true
    }
    func setWindow(){
        indicator.hideActivityIndicator(uiView: (self.window?.rootViewController?.view)!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVc = storyboard.instantiateViewController(withIdentifier: "surveyView") as! UINavigationController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = loginVc
        self.window?.makeKeyAndVisible()
    }
    func blankView(){
        // To avoid black effect
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.white
        self.window?.rootViewController = viewController
        
    }

   
}

