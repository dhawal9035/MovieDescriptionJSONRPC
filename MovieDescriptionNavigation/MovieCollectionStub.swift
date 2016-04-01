//
//  MovieCollectionStub.swift
//  MovieDescriptionNavigation
//  Copyright 2016 Dhawal Soni
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Created by dssoni on 3/19/16.
//  Copyright © 2016 dssoni. All rights reserved.
//

import Foundation

public class MovieCollectionStub {
    
    static var id:Int = 0
    
    var url:String
    
    init(urlString: String){
        self.url = urlString
    }
    
    
    // asyncHttpPostJson creates and posts a URLRequest that attaches a JSONRPC request as an NSData object
    func asyncHttpPostJSON(url: String,  data: NSData,
        callback: (String, String?) -> Void) {
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            request.HTTPBody = data
            sendHttpRequest(request, callback: callback)
    }
    
    // sendHttpRequest
    func sendHttpRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            // task.resume causes the shared session http request to be posted in the background (non-UI Thread)
            // the use of the dispatch_async on the main queue causes the callback to be performed on the UI Thread
            // after the result of the post is received.
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                if (error != nil) {
                    callback("", error!.localizedDescription)
                } else {
                    dispatch_async(dispatch_get_main_queue(),
                        {callback(NSString(data: data!,
                            encoding: NSUTF8StringEncoding)! as String, nil)})
                }
            }
            task.resume()
    }
    
    func get(name: String, callback: (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        MovieCollectionStub.id = MovieCollectionStub.id + 1
        do {
            let dict:[String:AnyObject] = ["jsonrpc":"2.0", "method":"get", "params":[name], "id":MovieCollectionStub.id]
            let reqData:NSData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(self.url, data: reqData, callback: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    func remove(name: String, callback: (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        MovieCollectionStub.id = MovieCollectionStub.id + 1
        do {
            let dict:[String:AnyObject] = ["jsonrpc":"2.0", "method":"remove", "params":[name], "id":MovieCollectionStub.id]
            let reqData:NSData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(self.url, data: reqData, callback: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    func add(movie: MovieDescription, callback: (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        MovieCollectionStub.id = MovieCollectionStub.id + 1
        do {
            
            let dict:[String:AnyObject] = ["jsonrpc":"2.0", "method":"addIos", "params":[movie.toJsonString()], "id":MovieCollectionStub.id]
            print("json string \(movie.toJsonString())")
            let reqData:NSData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(self.url, data: reqData, callback: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
    
    
    func getNames(callback: (String, String?) -> Void) -> Bool{
        var ret:Bool = false
        MovieCollectionStub.id = MovieCollectionStub.id + 1
        do {
            let dict:[String:AnyObject] = ["jsonrpc":"2.0", "method":"getNames", "params":[ ], "id":MovieCollectionStub.id]
            let reqData:NSData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
            self.asyncHttpPostJSON(self.url, data: reqData, callback: callback)
            ret = true
        } catch let error as NSError {
            print(error)
        }
        return ret
    }
    
}