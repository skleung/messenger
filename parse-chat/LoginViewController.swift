//
//  LoginViewController.swift
//  parse-chat
//
//  Created by Sherman Leung on 4/23/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  @IBOutlet var emailField: UITextField!
  @IBOutlet var passwordField: UITextField!
  @IBOutlet var errorLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func onLogin(sender: AnyObject) {
    var str = emailField.text as String
    var pass = passwordField.text as String
    PFUser.logInWithUsernameInBackground(emailField.text, password: passwordField.text, block: { (user:PFUser?, error:NSError?) -> Void in
    if user != nil {
    // Do stuff after successful login.
      self.performSegueWithIdentifier("ChatSegue", sender: self)
    } else {
      var alertView = UIAlertView(title: "Error!", message: "Login error", delegate: self, cancelButtonTitle: "Cancel")
      alertView.show()
    }
    })
    

  }
  @IBAction func onSignup(sender: AnyObject) {
    var user = PFUser()
    user.username = emailField.text
    user.password = passwordField.text
    user.email = emailField.text
    // other fields can be set just like with PFObject
    
    user.signUpInBackgroundWithBlock { (succeeded:Bool, error: NSError?) -> Void in
      if error == nil {
        self.performSegueWithIdentifier("ChatSegue", sender: self)
      } else {
        let errorString = error!.userInfo!["error"] as! NSString
        var alertView = UIAlertView(title: "Error!", message: errorString as String, delegate: self, cancelButtonTitle: "Cancel")
        alertView.show()
      }
    }
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
