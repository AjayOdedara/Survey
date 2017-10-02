//
//  ApiAccess.swift
//  TestAssign
//
//  Created by Ajay Odedra on 29/09/17.
//  Copyright © 2017 Ajay Odedra. All rights reserved.
//


import Foundation
import p2_OAuth2

public enum ApiMethod:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

open class ApiAccess : NSObject , URLSessionDataDelegate, URLSessionDelegate{
    
    
    public let apiRoot:String;
    private static var numberOfCallsToSetVisible = 0
    private static var hasRequestedRefreshToken = false
    private static var outstandingTasks = [String:URLSessionTask]()
    
    public init(apiRoot:String) {
        self.apiRoot = apiRoot
    }
    
    public final func performGetRequest(request:URLRequest?, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
        performRequest(theRequest: request, failOn401:false, success: success, failure: failure)
    }
    
    private func setNetworkActivityIndicatorVisible(setVisible:Bool){
        if(setVisible){
            ApiAccess.numberOfCallsToSetVisible += 1
            print("Number of Calls Incremented to: \(ApiAccess.numberOfCallsToSetVisible)")
        } else {
            if(ApiAccess.numberOfCallsToSetVisible >= 1){
                ApiAccess.numberOfCallsToSetVisible -= 1
                print("Number of Calls Decremented to: \(ApiAccess.numberOfCallsToSetVisible)")
            }
        }
        
        print("Number of Calls: \(ApiAccess.numberOfCallsToSetVisible)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = ApiAccess.numberOfCallsToSetVisible > 0
    }
    
    public final func performRequest(theRequest:URLRequest?, failOn401:Bool? = false, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
        
        if theRequest == nil {
            failure?( NSError(domain: NSURLErrorDomain, code: -999, userInfo: nil)) // treat it like a cancel
            return
        }
        
        var request = theRequest!
        
        let url = request.url!
        let minusQs = url.host! + url.path
        print("calling \(minusQs)")
        
        if let previousTask = ApiAccess.outstandingTasks[minusQs] {
            previousTask.cancel()
            self.setNetworkActivityIndicatorVisible(setVisible: false)
        }
        request.timeoutInterval = 60
        
        let task = oauth2.session.dataTask(with: request) { data, response, error in
            
            var returnedError:Error?;
            var returnedErrorTest:NSError?;
            
            ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
            if let errors = error {
                print(errors)
                returnedError = error
                returnedErrorTest = error! as Error as NSError
                print("Error Domain\(returnedErrorTest?.code)")
                if returnedErrorTest?.code != -999 || returnedErrorTest?.code != -1001{
                    print(returnedErrorTest?.description)
                }
                
                    ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
                    self.setNetworkActivityIndicatorVisible(setVisible: false)
            }
            else {
                
                    ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
                    if let httpResponse = response as! HTTPURLResponse?{
                        
                        let statusCode = httpResponse.statusCode
                        var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        
                        print("\n*****-----------*****\nURL: \(response!.url!)\nStatus Code:\(statusCode)\n*****-----------*****\n")
                        if statusCode == 200 || statusCode == 201 {
                            DispatchQueue.main.async() {
                                if let response = responseString{
                                    success(response as String)
                                }else{
                                    responseString = "N/A"
                                    success(responseString as! String)
                                }
                            }
                        }else if statusCode == 204 { // no content
                            DispatchQueue.main.async() {
                                success("No Content")
                            }
                        }else if statusCode == 401 {
                            // unauthorized. Use one retry.
                            if let fail = failOn401, fail == true {
                                // send the notification that we've been forced out
                                print("Got a 401 when we're supposed to fail on 401, so log them out")
                                print(responseString ?? "Error")
                                DispatchQueue.main.async(execute: { () -> Void in
                                    failure!(error! as NSError)
                                    return
                                })
                            }else{
                                oauth2.authorize() { authParameters, error in
                                    if let params = authParameters {
                                        self.cancelAllCurrentRequests()
                                        
                                        let url = NSURL(string: self.apiRoot + "surveys.json?page=1&per_page=10")!
                                        let requestFor = oauth2.request(forURL: url as URL)
                                        self.performRequest(theRequest: requestFor, failOn401:true, success:success, failure:failure)
                                    }
                                    else {
                                        print(error?.asOAuth2Error.description)
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            failure!(error! as NSError)
                                            return
                                        })
                                    }
                                }
                            }
                            
                        }else{
                            // Other Status Code
                            var descr: String = ""
                            
                            do {
                                let errorDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                                if let something = errorDict["errorMessage"] as? String{
                                    descr = something
                                }
                                descr = descr.replacingOccurrences(of: "[\"", with: "")
                                descr = descr.replacingOccurrences(of: "\"]", with: "")
                            } catch let error as NSError {
                                print("\n**********\nURL: \(response!.url!)\nJson Serialization error: \(error.localizedDescription)\nStatus Code:\(statusCode)\n***********\n")
                            }
                            
                            if (descr == "") {
                                descr = "Error code \(statusCode): '\(responseString!)'"
                            }
                            returnedError = NSError(domain: Constant.ApiErrorDomain, code: statusCode, userInfo:[NSLocalizedDescriptionKey:descr])
                            DispatchQueue.main.async(execute: { () -> Void in
                                failure!(returnedError! as NSError)
                                return
                            })
                            
                        }
                        self.setNetworkActivityIndicatorVisible(setVisible: false)
                        
                
                    }
                
                
            }
            
            if let anError = returnedError, let failure = failure {
                self.setNetworkActivityIndicatorVisible(setVisible: false)
                DispatchQueue.main.async(execute: { () -> Void in
                    failure(anError as NSError)//failure(anError.isCancel() ? nil : anError)
                })
            }
            
        }
        
        ApiAccess.outstandingTasks[minusQs] = task
        task.resume()
        self.setNetworkActivityIndicatorVisible(setVisible: true)
      
    }
    private func cancelAllCurrentRequests(){
        ApiAccess.outstandingTasks.removeAll()
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)" as AnyObject)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
    }
}
