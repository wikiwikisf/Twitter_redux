//
//  ContainerViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/10/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  var homeViewController : HomeTableViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavButtons()
    
    // Load home timeline by default
    homeViewController = UIStoryboard.homeViewController()
    //homeViewController.delegate = self
    
    addChildViewController(homeViewController)
   
    view.addSubview(homeViewController.view)
    
   /* let subviewConstraint = NSLayoutConstraint(item: homeViewController.view,
      attribute: .Top,
      relatedBy: .Equal,
      toItem: self.view,
      attribute: .Top,
      multiplier: 1,
      constant: 50)
    view.addConstraint(subviewConstraint)
    homeViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    */
    
    homeViewController.didMoveToParentViewController(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setupNavButtons() {
    // Setup logout button in navigation bar
    let logoutButton = UIBarButtonItem()
    logoutButton.title = "Sign Out"
    logoutButton.action = Selector("logout")
    logoutButton.target = self
    navigationItem.leftBarButtonItem = logoutButton

    // Setup New button in navigation bar
    let newButton = UIBarButtonItem()
    newButton.title = "New"
    newButton.action = Selector("composeTweet")
    newButton.target = self
    navigationItem.rightBarButtonItem = newButton
    
    navigationItem.title = "Home"
  }
  
  internal func logout() {
    User.currentUser?.logout()
  }
  
  internal func composeTweet() {
    // segue to new tweet
    performSegueWithIdentifier("newTweetSegue", sender: self)
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

private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func homeViewController() -> HomeTableViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("HomeTableViewController") as? HomeTableViewController
  }
  
  // TODO add profile and mentions view controllers
  
}
