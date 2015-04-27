//
//  registerUserViewController.swift
//  blow
//
//  Created by Tainara Specht on 4/8/15.
//  Copyright (c) 2015 Tainara Specht. All rights reserved.
//

import UIKit

class registerUserViewController: UIViewController {

    @IBOutlet weak var firstNameTxtField: UITextField! = UITextField()
    @IBOutlet weak var lastNameTxtField: UITextField! = UITextField()
    @IBOutlet weak var emailTxtField: UITextField! = UITextField()
 

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let firstNameIsNotNill = defaults.objectForKey("firstName") as? String {
            self.firstNameTxtField.text = defaults.objectForKey("firstName") as! String
        }
        
        if let lastNameIsNotNill = defaults.objectForKey("lastName") as? String {
            self.lastNameTxtField.text = defaults.objectForKey("lastName") as! String
        }
        
        if let emailIsNotNill = defaults.objectForKey("email") as? String {
            self.emailTxtField.text = defaults.objectForKey("email") as! String
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(self.firstNameTxtField.text, forKey: "firstName")
        defaults.setObject(self.lastNameTxtField.text, forKey: "lastName")
        defaults.setObject(self.emailTxtField.text, forKey: "email")
        
        defaults.synchronize()
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                bottomConstraint.constant = keyboardHeight
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

}
