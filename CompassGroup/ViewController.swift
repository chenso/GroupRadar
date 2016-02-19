//
//  ViewController.swift
//  CompassGroup
//
//  Created by Songge Chen on 2/17/16.
//  Copyright © 2016 Songge Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var lapsce: GroupModel = GroupModel(group_id: 1);
        sleep(4)
        print(lapsce.description)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

