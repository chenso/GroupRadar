//
//  GroupModel.swift
//  CompassGroup
//
//  Created by Songge Chen on 2/17/16.
//  Copyright © 2016 Songge Chen. All rights reserved.
//

import UIKit

class GroupModel: NSObject, NSURLSessionDataDelegate {
    var groupName : String?
    var group_id : Int?
    var groupUsers : Set<UserModel> = Set<UserModel>()
    
    var data : NSMutableData = NSMutableData()
    
    override init() {}
    
    // Retrieve group information from server
    init(group_id : Int) {
        super.init()
        
        self.group_id = group_id
        let url_path = "http://ec2-52-32-204-127.us-west-2.compute.amazonaws.com/~chens/groupuserrequest.php?groupid=\(group_id)"
        print(url_path)
        let group_user_request_url : NSURL = NSURL(string: url_path)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithURL(group_user_request_url)
        task.resume()
    }
    
    // New group creation
    // Push group to server and retrieve group id
    init(group_name : String) {
        super.init()
        
        
    }
    
    override var description: String {
        var user_description_acc : String
        if (group_id != nil) {
            user_description_acc = "Group \(group_id!): \n"
        } else {
            user_description_acc = "Group ID nil:"
        }
        for um in groupUsers {
            user_description_acc += "\t" + um.description + "\n"
        }
        return user_description_acc
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
            self.parseGroupJSON()
        }
        
    }
    
    func parseGroupJSON() {
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do{
            jsonResult = try NSJSONSerialization.JSONObjectWithData(self.data, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        
        for (var i = 0; i < jsonResult.count; i++) {
            jsonElement = jsonResult[i] as! NSDictionary
            if let username = jsonElement["username"] as? String,
                let latitude = jsonElement["latitude"] as? String,
                let longitude = jsonElement["longitude"] as? String,
                let user_id = Int((jsonElement["user_id"] as? String)!) {
                    let um : UserModel = UserModel(username: username, latitude: latitude, longitude : longitude, user_id: user_id)
                    groupUsers.insert(um);
            }
        }
    }
    
}
