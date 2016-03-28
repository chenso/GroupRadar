//
//  ViewController.swift
//  CompassGroup
//
//  Created by Songge Chen on 2/17/16.
//  Copyright © 2016 Songge Chen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate, UIApplicationDelegate {

    @IBOutlet weak var grouplabel: UILabel?
    @IBOutlet weak var userlabel: UILabel?
    @IBOutlet weak var updateButton: UIButton?
    
    var locationManager : CLLocationManager!
    var lat = 0.0
    var long = 0.0
    var me: UserModel = UserModel(user_id: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        userlabel!.lineBreakMode = .ByWordWrapping
        
        var grp: GroupModel = GroupModel(group_id: 1)

        me.sendUpdateLocation(String(format:"%f", lat), longitude: String(format:"%f", long))
        sleep(2)
        print(grp.description)
        print(me.description)
        
/*
        //let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
                //me.updateLocation(String(format:"%f", lat), longitude: String(format:"%f", long))
                //me.sendUpdateLocation(String(format:"%f", lat), longitude: String(format:"%f", long))
                me.requestLocation()
                //dispatch_async(dispatch_get_main_queue()) {
                    // update some UI
                    self.userlabel?.text = me.description
          //      }
        //}*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        //
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        //
    }
    
    @IBAction func updateLocation(sender: UIButton) {
        me.requestLocation()
        lat += 0.4
        long += 0.6
        me.sendUpdateLocation(String(format:"%.2f", lat), longitude: String(format:"%.2f", long))
        
        self.userlabel?.text = me.description
        
    }

}

