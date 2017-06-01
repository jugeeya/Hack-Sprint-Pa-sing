//
//  DummyViewController.swift
//  passing
//
//  Created by Grant Schulte on 5/24/17.
//  Copyright © 2017 Xiwei M. All rights reserved.
//


import UIKit


class DummyViewController: UIViewController {
    
    var isUsersFirstTime: Bool = true
    
    // ##########################################
    // ##########################################
    // ##########################################
    // ##########################################
    let CLEAR_FIRST_TIME_STATUS: Bool = false
    // ##########################################
    // ##########################################
    // ##########################################
    // ##########################################
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!CLEAR_FIRST_TIME_STATUS) {
            
            if let firstTime = UserDefaults.standard.value(forKey: "firstTime") as? Bool {
                if ( firstTime == false ) {
                    self.isUsersFirstTime = false
                    performSegue(withIdentifier: "NotFirstTime", sender: nil)
                    print("Performing segue from DummyVC to main VC (key firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime"))))")
                } else {
                    self.isUsersFirstTime = true
                    performSegue(withIdentifier: "FirstTime", sender: nil)
                    print("Performing segue from DummyVC to SettingsVC (key firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime"))))")
                }
            } else {
                self.isUsersFirstTime = true
                UserDefaults.standard.set(true, forKey: "firstTime")
                performSegue(withIdentifier: "FirstTime", sender: nil)
                print("Performing segue from DummyVC to SettingsVC (key firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime"))))")
            }
            
        } else {
            
            /* Remove any and all user defaults previously added: (i.e. firstTime status, password, and textPassword) */
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            print("Cleared user defaults. firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime")))")
            performSegue(withIdentifier: "FirstTime", sender: nil)
            print("Performing segue from DummyVC to SettingsVC (key firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime"))))")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FirstTime" {
            if let destinationVC = segue.destination as? SettingsViewController {
                destinationVC.firstTime = self.isUsersFirstTime
            }
        }
    }
    
    
}



