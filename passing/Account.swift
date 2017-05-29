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
    
    func openURL() {
        if (url != nil) {
            UIApplication.shared.openURL(url!)
        }
    }
    
}

