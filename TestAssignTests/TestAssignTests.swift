//
//  TestAssignTests.swift
//  TestAssignTests
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//

import XCTest
import p2_OAuth2
@testable import TestAssign

class TestAssignTests: XCTestCase {
    
    var coreRepo = CoreRepository(apiRoot: Constant.apiRoot)
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReAuth(){
        
        self.coreRepo.getSurveys(onCompletion: { (data) in
            print("success")
        }) { (error) in
            print(error?.localizedDescription ?? "Error")
        }

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            oauth2 = MobileOAuthPasswordGrant(userName: Constant.Config.username, password: Constant.Config.password)
            oauth2.authorize() { authParameters, error in
                if let params = authParameters {
                    print("Authorized! Access token is in `oauth2.accessToken`")
                    print("Authorized! Additional parameters: \(params)")
                }
                else {
                    
                    print(error?.localizedDescription ?? "Error")
                }
            }

        }
    }
    
}
