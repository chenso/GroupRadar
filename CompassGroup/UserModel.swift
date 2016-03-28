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
        self.user_id = user_id
        requestLocation()
    }
    
    init(username: String, latitude: String, longitude: String, user_id: Int) {
        self.username = username
        self.latitude = latitude
        self.longitude = longitude
        self.user_id = user_id
    }
    
    func updateLocation(latitude: String, longitude: String) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    func requestLocation() {
        let user_request_url  = HTTPHelper.getUserURL(user_id!)
        sendRequest(user_request_url)
    }
    
    private func sendUpdateLocation() {
        let user_update_url = HTTPHelper.updateUserURL(self.user_id!, longitude: self.longitude!, latitude: self.latitude!)

        sendRequest(user_update_url)
    }
    
    func sendUpdateLocation(latitude: String, longitude: String) {
        let user_update_url = HTTPHelper.updateUserURL(self.user_id!, longitude: longitude, latitude: latitude)
        sendRequest(user_update_url)
    }
    
    private func sendRequest(url: NSURL) {
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithURL(url)
        task.resume()
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
        self.data.setData(NSData()) // TODO: make this work better asynchronously 
        self.data.appendData(data)
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
    
    override var hashValue : Int {
        return self.user_id!;
    }
    
    
}

func ==(lhs: UserModel, rhs: UserModel) -> Bool {
    return lhs.user_id == rhs.user_id;
}
