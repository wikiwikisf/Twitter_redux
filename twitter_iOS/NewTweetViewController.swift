//
//  NewTweetViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/4/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
  
  @IBOutlet var newTweetView: NewTweetView!
  
  var replytweetId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // Setup Tweet button in navigation bar
    let tweetButton = UIBarButtonItem()
    tweetButton.title = "Tweet"
    tweetButton.action = Selector("submitTweet")
    tweetButton.target = self
    navigationItem.rightBarButtonItem = tweetButton
    
    // Setup Cancel button in navigation bar
    let cancelButton = UIBarButtonItem()
    cancelButton.title = "Cancel"
    cancelButton.action = Selector("cancelTweet")
    cancelButton.target = self
    navigationItem.leftBarButtonItem = cancelButton

    setupNewTweetView()
  }
  
  override func viewDidAppear(animated: Bool) {
    // Make the text field the first responder
    print("view did appear")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  internal func submitTweet() {
    print("submit tweet")
    if (replytweetId != nil) {
      TwitterClient.instance.replyTweet(newTweetView.tweetTextField.text!, tweetId: replytweetId!) { (tweet, error) -> () in
        if (error == nil) {
          // Segue back to the Home view and refresh the homeview
          print("return to home view")
          self.dismissViewControllerAnimated(true, completion: nil)
        }
      }
    } else {
      TwitterClient.instance.postTweet(["status" : newTweetView.tweetTextField.text!]) { (tweet, error) -> () in
        if (error == nil) {
          // Segue back to the Home view and refresh the homeview
          print("return to home view")
          // Add the new tweet to the home timeline
          let nc = self.presentingViewController as! UINavigationController
          let homeVC = nc.viewControllers[0] as! HomeTableViewController
          homeVC.homeTweets.insert(tweet!, atIndex: 0)
          homeVC.tableView.reloadData()
          
          self.dismissViewControllerAnimated(true, completion: nil)
        }
      }
    }
  }
  
  internal func setupNewTweetView() {
    let user = User.currentUser
    let userProfilePicUrl = user?.profileImageURL
    newTweetView.profilePicImage.setImageWithURL(NSURL(string: userProfilePicUrl!))
    newTweetView.userNameLabel.text = user?.name
    let screenName = user?.screenName
    newTweetView.screenNameLabel.text = "@\(screenName!)"
  }
  
  internal func cancelTweet() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - Navigation
  /*
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let navigationController = segue.destinationViewController as! UINavigationController
    for view in navigationController.viewControllers {
      
    }
  }*/
  
}
