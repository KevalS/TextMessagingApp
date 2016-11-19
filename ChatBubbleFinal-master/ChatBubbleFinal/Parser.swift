//
//  Parser.swift
//  ChatBubbleFinal
//


import UIKit
import CoreLocation

class Parser: NSObject {
    var urlSession : NSURLSession!
    override init() {
        
        super.init()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
        
    }
    func appSetting(completionClosure: (repos :NSDictionary) ->())  {
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://hitme-dev.us-west-2.elasticbeanstalk.com/api/all-messages/")!)
        request.timeoutInterval = 20
        print(request)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postDataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if (error != nil) {
                print(error!.localizedDescription)
            }
            
            if(data != nil) {
                if let jsonResult: NSDictionary  = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                {
                    completionClosure(repos: jsonResult)
                    print(jsonResult)
                }
                else
                {
                    completionClosure(repos: NSDictionary())
                }
            }  else {
                completionClosure(repos: NSDictionary())
            }
        })
        postDataTask.resume()
    }
    

   


}

