//
//  SettingsViewController.swift
//  passing
//
//  Created by Grant Schulte on 5/24/17.
//  Copyright © 2017 Xiwei M. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    var firstTime: Bool = false
    
    // ###########################################################
    // #################### READ THIS PLEASE #####################
    // ###########################################################
    // ##                                                       ##
    // ## Once the user finishes setting up a password and      ##
    // ## clicks "Save" or whatever, run these lines of code:   ##
    // ##                                                       ##
    // ## UserDefaults.standard.set(false, forKey: "firstTime") ##
    // ## self.firstTime = false                                ##
    // ##                                                       ##
    // ## This will keep track of the fact that the user has    ##
    // ## already set up a password so that he/she will be      ##
    // ## directed to the correct launch screen next time       ##
    // ## he/she opens the app!                                 ##
    // ##                                                       ##
    // ## Thanks!                                               ##
    // ## -Grant                                                ##
    // ##                                                       ##
    // ###########################################################
    // #################### READ THIS PLEASE #####################
    // ###########################################################
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


