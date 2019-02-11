//
//  SettingsTableNav.swift
//  SalaryCalc
//
//  Created by Bartek  on 2017-10-27.
//  Copyright © 2017 Bartek . All rights reserved.
//

import UIKit

class SettingsTableNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationBar.barTintColor = .white
        self.navigationBar.tintColor = .black
        // Do any additional setup after loading the view.
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
}
