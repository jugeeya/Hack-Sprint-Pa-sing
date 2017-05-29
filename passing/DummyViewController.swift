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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if let firstTime = UserDefaults.standard.value(forKey: "firstTime") as? Bool {
            if ( firstTime == false ) {
                self.isUsersFirstTime = false
                performSegue(withIdentifier: "NotFirstTime", sender: nil)
                print("Performing segue from DummyVC to main VC (key firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime"))))")
            } else {
                UserDefaults.standard.set(false, forKey: "firstTime")
                self.isUsersFirstTime = true
                performSegue(withIdentifier: "FirstTime", sender: nil)
                print("Performing segue from DummyVC to SettingsVC (key firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime"))))")
            }
        } else {
            UserDefaults.standard.set(false, forKey: "firstTime")
            performSegue(withIdentifier: "FirstTime", sender: nil)
            print("Performing segue from DummyVC to SettingsVC (key firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime"))))")
        }*/
        
        /* Remove any and all user defaults previously added: */
          UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
          UserDefaults.standard.synchronize()
          print("Cleared user defaults. firstTime = \(String(describing: UserDefaults.standard.value(forKey: "firstTime")))")
        performSegue(withIdentifier: "NotFirstTime", sender: nil)
        
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



