//
//  ChatViewController.swift
//  parse-chat
//
//  Created by Sherman Leung on 4/23/15.
//  Copyright (c) 2015 Sherman Leung. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{

  @IBOutlet var messageField: UITextField!
  @IBOutlet var composeButton: UIBarButtonItem!
  
  @IBOutlet var tableView: UITableView!
  
  var messages = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "onRefresh", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func composeMessage(sender: AnyObject) {
    var msg = PFObject(className: "Message")
    msg["text"] = messageField.text
    msg["user"] = PFUser.currentUser()?.username
    
    msg.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
      if (success) {
        self.tableView.reloadData()
      } else {
        var alertView = UIAlertView(title: "Error!", message: error?.description, delegate: self, cancelButtonTitle: "Cancel")
        alertView.show()
      }
    }
  }
  
  func onRefresh() {
    var query = PFQuery(className:"Message")
    query.orderByDescending("createdAt")
    query.findObjectsInBackgroundWithBlock {
      (objects: [AnyObject]?, error: NSError?) -> Void in
      if error == nil {
        // The find succeeded.
        println("Successfully retrieved \(objects!.count) scores.")
        // Do something with the found objects
        if let objects = objects as? [PFObject] {
          self.messages = objects
          println(self.messages.count)
          self.tableView.reloadData()
          for object in objects {
            println(object["text"])
          }
        }
        
      } else {
        // Log details of the failure
        println("Error: \(error!) \(error!.userInfo!)")
      }
    }
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
  
    
    var username = messages[indexPath.row]["user"] as? String
    if let temp = username {
      cell.userLabel.text = temp
    } else {
      cell.userLabel.text = "Anon"
    }
    cell.messageLabel.text = messages[indexPath.row]["text"] as! String
    return cell
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
