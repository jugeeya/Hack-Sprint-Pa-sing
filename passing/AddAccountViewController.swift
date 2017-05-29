//
//  AddAccountViewController.swift
//  passing
//
//  Created by Grant Schulte on 5/24/17.
//  Copyright © 2017 Xiwei M. All rights reserved.
//

import UIKit


class AddAccount_AccountInfoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
}


class AddAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var accountTypePicker: UIPickerView!
    @IBOutlet weak var accountTypeImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let pickerData = [ "Custom Account", "Google", "Facebook", "Twitter", "Instagram", "Snapchat", "myUCLA" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        accountTypePicker.delegate = self
        accountTypePicker.dataSource = self
        
        // Disallow scrolling in the table... it is just there to keep stuff neat.
        tableView.isScrollEnabled = false
        
        accountTypeImage.image = #imageLiteral(resourceName: "DefaultAccountIcon")
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddAccountViewController.dismissKeyboard))
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let accountTypeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddAccount_AccountInfoCell
        let urlCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! AddAccount_AccountInfoCell
        
        
        // let pickerData = [ "Custom Account", "Google", "Facebook", "Twitter", "Instagram", "Snapchat", "myUCLA" ]
        switch row {
        case 0:  // Custom Account
            accountTypeImage.image = #imageLiteral(resourceName: "DefaultAccountIcon")
            accountTypeCell.isUserInteractionEnabled = true
            accountTypeCell.textField.text = ""
            urlCell.isUserInteractionEnabled = true
            urlCell.textField.text = ""
            break
            
        case 1:  // Google
            accountTypeImage.image = #imageLiteral(resourceName: "GoogleIcon")
            accountTypeCell.isUserInteractionEnabled = false
            accountTypeCell.textField.text = "Google"
            urlCell.isUserInteractionEnabled = false
            urlCell.textField.text = "https://www.google.com/"
            break
            
        case 2:  // Facebook
            accountTypeImage.image = #imageLiteral(resourceName: "FacebookIcon")
            accountTypeCell.isUserInteractionEnabled = false
            accountTypeCell.textField.text = "Facebook"
            urlCell.isUserInteractionEnabled = false
            urlCell.textField.text = "fb://"
            break
            
        case 3:  // Twitter
            accountTypeImage.image = #imageLiteral(resourceName: "TwitterIcon")
            accountTypeCell.isUserInteractionEnabled = false
            accountTypeCell.textField.text = "Twitter"
            urlCell.isUserInteractionEnabled = false
            urlCell.textField.text = "twitter://"
            break
            
        case 4:  // Instagram
            accountTypeImage.image = #imageLiteral(resourceName: "InstagramIcon")
            accountTypeCell.isUserInteractionEnabled = false
            accountTypeCell.textField.text = "Instagram"
            urlCell.isUserInteractionEnabled = false
            urlCell.textField.text = "instagram://"
            break
            
        case 5:  // Snapchat
            accountTypeImage.image = #imageLiteral(resourceName: "SnapchatIcon")
            accountTypeCell.isUserInteractionEnabled = false
            accountTypeCell.textField.text = "Snapchat"
            urlCell.isUserInteractionEnabled = false
            urlCell.textField.text = "snapchat://"
            break
            
        case 6:  // myUCLA
            accountTypeImage.image = #imageLiteral(resourceName: "UCLAIcon")
            accountTypeCell.isUserInteractionEnabled = false
            accountTypeCell.textField.text = "myUCLA"
            urlCell.isUserInteractionEnabled = false
            urlCell.textField.text = "my.ucla.edu"
            break
            
        default:
            break
        }
        
    }
    
    
    // Must manually implement these 3 below functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Set the number of rows in a section to be the number of items
        return 5  // Account type, Username, Password, URL, Comments
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountInfoCell", for: indexPath) as! AddAccount_AccountInfoCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Account Type:"
            cell.textField.placeholder = "Enter account info..."
        case 1:
            cell.titleLabel.text = "Username:"
            cell.textField.placeholder = "Enter account info..."
            break
        case 2:
            cell.titleLabel.text = "Password:"
            cell.textField.placeholder = "Enter account info..."
            break
        case 3:
            cell.titleLabel.text = "URL"
            cell.textField.placeholder = "Enter account info... (Optional)"
            break
        case 4:
            cell.titleLabel.text = "Comments:"
            cell.textField.placeholder = "Enter account info... (Optional)"
        default:
            break
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Account Details"
    }
    
    
    @IBAction func clickedSaveButton(_ sender: UIButton) {
        
        let accountTypeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddAccount_AccountInfoCell
        let usernameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! AddAccount_AccountInfoCell
        let passwordCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! AddAccount_AccountInfoCell
        let urlCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! AddAccount_AccountInfoCell
        let commentsCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! AddAccount_AccountInfoCell
        
        // Prepare an alert...
        let alertController = UIAlertController(title: "Add a New Account", message: "Please make sure all required fields have been filled in, then try again.", preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style:.default) { (action:UIAlertAction) in print("Failed to add new account because not all required fields were filled in.") }
        alertController.addAction(OKAction)
        
        // Check for if all fields are satisfied, then segue. If not, show the alert.
        if accountTypeCell.textField.text != "" {
            if usernameCell.textField.text != "" {
                if passwordCell.textField.text != "" {
                    performSegue(withIdentifier: "accountCreated", sender: nil)
                }
            } else {
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // Store all inputted information in an "Account" object and pass it to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let accountTypeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddAccount_AccountInfoCell
        let usernameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! AddAccount_AccountInfoCell
        let passwordCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! AddAccount_AccountInfoCell
        let urlCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! AddAccount_AccountInfoCell
        let commentsCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! AddAccount_AccountInfoCell
        
        if (segue.identifier == "accountCreated") {
            
            let account = Account(type: accountTypeCell.textField.text!, username: usernameCell.textField.text!, password: passwordCell.textField.text!, url: urlCell.textField.text!, comments: commentsCell.textField.text!, image: accountTypeImage.image!)
            if let destinationVC = segue.destination as? InfoViewController {
                destinationVC.account = account
                
            }
            
        }
        
    }
    
    
    @IBAction func unwindSegueToEditAccount(_ sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? InfoViewController {
            
            let accountTypeCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddAccount_AccountInfoCell
            let usernameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! AddAccount_AccountInfoCell
            let passwordCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! AddAccount_AccountInfoCell
            let urlCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! AddAccount_AccountInfoCell
            let commentsCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! AddAccount_AccountInfoCell
            
            let account = sourceVC.account
            
            accountTypeCell.textField.text = account.type
            usernameCell.textField.text = account.username
            passwordCell.textField.text = account.password
            urlCell.textField.text = account.url?.absoluteString
            commentsCell.textField.text = account.comments
            accountTypeImage.image = account.image
            
            // Set the account-type picker to select the appropriate account-type option
            var i: Int = 0
            var found: Bool = false
            for x in pickerData {
                if (x == accountTypeCell.textField.text) {
                    found = true
                    accountTypePicker.selectRow(i, inComponent: 0, animated: true)
                }
                i += 1
            }
            if (!found) {
                accountTypePicker.selectRow(0, inComponent: 0, animated: true)
            }
        }
        
    }
    
    
}











