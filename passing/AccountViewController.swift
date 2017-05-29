//
//  AccountViewController.swift
//  passing
//
//  Created by Grant Schulte on 5/24/17.
//  Copyright © 2017 Xiwei M. All rights reserved.
//

import UIKit


class AccountViewController: UIViewController {
    
    // Array containing all of the user's accounts
    var accounts: [Account] = []
    
    @IBAction func printAccountNumButton(_ sender: Any) {
        print(accounts.count)
    }
    
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
    
    
    @IBAction func unwindSegueToAccountList(_ sender: UIStoryboardSegue) {
        // If pressed "Done", the user wants to add a new account to his/her list
        // If pressed "Cancel", the user doesn't want to add any new accounts
        if let sourceVC = sender.source as? InfoViewController {
            accounts.append(sourceVC.account)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Set the number of rows in a section to be the number of accounts
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath)
        
        // Code here to make cell display the correct (1) Account Type, (2) Username, and (3) Image...
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "User Accounts"
    }
    
    
}
