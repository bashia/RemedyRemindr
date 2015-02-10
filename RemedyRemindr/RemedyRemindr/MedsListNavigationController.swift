//
//  MedsListNavigationController.swift
//  RemedyRemindr
//
//  Created by Tony on 2015-02-09.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class MedsListNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Color the navigation bar to fit in with the blue theme
        var appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        appearance.barTintColor = UIColor(red: 93/255, green: 149/255, blue: 210/255, alpha: 1.0)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
