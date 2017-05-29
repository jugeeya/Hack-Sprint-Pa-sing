//
//  Account.swift
//  passing
//
//  Created by Grant Schulte on 5/28/17.
//  Copyright © 2017 Xiwei M. All rights reserved.
//

import UIKit

class Account {
    
    var type: String
    var username: String
    var password: String
    var url: URL?
    var comments: String?
    var image: UIImage
    
    
    init(type: String, username: String, password: String, url: String?, comments: String?, image: UIImage) {
        self.type = type
        self.username = username
        self.password = password
        if (url != nil) {
            self.url = URL(string: url!)
        }
        self.comments = comments
        self.image = image
    }
    
    init() {
        type = "Default"
        username = "Default"
        password = "Default"
        url = nil
        comments = "Default"
        image = #imageLiteral(resourceName: "DefaultAccountIcon")
    }
    
    func openURL(viewController: UIViewController) {
        if (url != nil) {
            //if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            /*} else {
                print("Cannot open URL because it is not a valid URL")
            }*/
        } else {
            let alertController = UIAlertController(title: "Open URL", message: "Error: It appears that no URL was provided for this account type.", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "OK", style:.default) { (action:UIAlertAction) in
                print("Cannot open URL because account.url is nil");}
            alertController.addAction(OKAction)
            viewController.present(alertController, animated: true, completion: nil)
            
        }
    }
    
}

