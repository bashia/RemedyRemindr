//
//  MedsListNavigationController.swift
//  RemedyRemindr
//
//  Created by RemedyRemindr Team on 2015-02-09.
//  Copyright (c) 2015 Group 4. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Color the navigation bar to fit in with the blue theme
        var appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        appearance.barTintColor = darkBlueThemeColor
        appearance.tintColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
