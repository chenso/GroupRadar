//
//  HTTPHelper.swift
//  CompassGroup
//
//  Created by Songge Chen on 2/18/16.
//  Copyright © 2016 Songge Chen. All rights reserved.
//

import Foundation

class HTTPHelper {
    static let realm = "http://ec2-52-32-204-127.us-west-2.compute.amazonaws.com/~chens/"
    
    class func getUserURL(user_id : Int) -> NSURL {
        let url_path = realm + "userrequest.php?userid=\(user_id)"
        return NSURL(string: url_path)!
    }
    
    class func getGroupURL(group_id : Int) -> NSURL {
        let url_path = realm + "groupuserrequest.php?groupid=\(group_id)"
        return NSURL(string: url_path)!
    }
    
    class func updateUserURL(user_id : Int, longitude : String, latitude: String) -> NSURL {
        let url_path = realm + "userupdate.php?userid=\(user_id)&longitude=\(longitude)&latitude=\(latitude)"
        return NSURL(string: url_path)!
    }
}