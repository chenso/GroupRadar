//
//  UserModel.swift
//  CompassGroup
//
//
// The UserModel class stores user information and location for a given user
// This class allows user information to be retrieved and a UserModel to be initialized
// given a user_id. 
//
//  Created by Songge Chen on 2/17/16.
//  Copyright © 2016 Songge Chen. All rights reserved.

import UIKit

class UserModel: NSObject, NSURLSessionDataDelegate {
    var username: String?
    var latitude: String?
    var longitude: String?
    var user_id: Int?
    
    var data : NSMutableData = NSMutableData()
    
    override init() {}
    
    // initializes UserModel based on given user_id. 
    // sends request URL to backend to retrieve json formatted response
    init(user_id : Int) {
        super.init()
        self.user_id = user_id;
        
        /* url_path for retrieving all fields for a user given user_id */
        let url_path = "http://ec2-52-32-204-127.us-west-2.compute.amazonaws.com/~chens/userrequest.php?userid=\(user_id)"
        let user_request_url : NSURL = NSURL(string: url_path)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithURL(user_request_url)
        task.resume()
    }
    
    init(username: String, latitude: String, longitude: String, user_id: Int) {
        self.username = username
        self.latitude = latitude
        self.longitude = longitude
        self.user_id = user_id
    }
    
    override var description: String {
        if username != nil && longitude != nil && latitude != nil {
            return "Username: \(username!), longitude: \(longitude!), latitude: \(latitude!)"
        } else {
            return "Invalid User"
        }
    }
    
    // MARK: NSURLSessionDataDelegate methods
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data);
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            self.parseUserJSON()
        }
        
    }
    
    func parseUserJSON() {
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do{
            jsonResult = try NSJSONSerialization.JSONObjectWithData(self.data, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        
        jsonElement = jsonResult[0] as! NSDictionary // there should only be one result for a given user_id
        
        parseJSONElement(jsonElement)
    }
    
    func parseJSONElement(jsonElement : NSDictionary) {
        //the following insures none of the JsonElement values are nil through optional binding
        if let name = jsonElement["username"] as? String,
            let latitude = jsonElement["latitude"] as? String,
            let longitude = jsonElement["longitude"] as? String
        {
            self.username = name
            self.latitude = latitude
            self.longitude = longitude
            
        }
    }
}
