//
//  ContainerViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/10/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  enum SlideOutState {
    case MenuCollapsed
    case MenuExpanded
  }
  
  private var homeViewController : HomeTableViewController!
  private var hamburgerViewController : HamburgerViewController!
  private var mentionsViewController : MentionsTableViewController!
  private var profileViewController : ProfileViewController!
  private var currentState : SlideOutState = .MenuCollapsed
  private var selectedViewController: UIViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavButtons()
    
    // Load home timeline by default
    homeViewController = UIStoryboard.homeViewController()
    selectViewController(homeViewController)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    view.addGestureRecognizer(panGestureRecognizer)
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
  
  internal func addMenuViewController() {
    if hamburgerViewController == nil {
      hamburgerViewController = UIStoryboard.hamburgerViewController()
      hamburgerViewController.delegate = self
    }

    addChildViewController(hamburgerViewController)
    hamburgerViewController.view.frame = view.bounds
    hamburgerViewController.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    view.insertSubview(hamburgerViewController.view, atIndex: 0)
    
    hamburgerViewController.didMoveToParentViewController(self)
    
    // set the current state
    currentState = .MenuExpanded
  }
  
  internal func removeMenuViewController() {
    if currentState == .MenuExpanded {
      if hamburgerViewController == nil {
        hamburgerViewController = UIStoryboard.hamburgerViewController()
      }
      
      hamburgerViewController.willMoveToParentViewController(nil)
      //hamburgerViewController.view.removeFromSuperview()
      hamburgerViewController.removeFromParentViewController()
    
      // set the current state
      currentState = .MenuCollapsed
    }
  }

  internal func selectViewController(vc: UIViewController) {
    if let oldViewController = selectedViewController {
      oldViewController.willMoveToParentViewController(nil)
      oldViewController.view.removeFromSuperview()
      oldViewController.removeFromParentViewController()
    }
    
    if currentState == .MenuExpanded {
      removeMenuViewController()
    }
    
    addChildViewController(vc)
    // set constraints?
    view.addSubview(vc.view)
    vc.didMoveToParentViewController(self)
    
    selectedViewController = vc
  }
  
  internal func animateMenuPanel(shouldShowMenu: Bool){
    if shouldShowMenu {
      animateSelectedViewXPosition(0.0)

    } else {
      animateSelectedViewXPosition(CGRectGetWidth(selectedViewController!.view.frame) - 140.0)

    }
  }
  
  internal func animateSelectedViewXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
      self.selectedViewController!.view.frame.origin.x = targetPosition
      }, completion: completion)
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

// MARK: Gesture recognizer
extension ContainerViewController: UIGestureRecognizerDelegate {
  
  func handlePanGesture(recognizer: UIPanGestureRecognizer) {
    // if the menu view controller is not currently seen, show it
    let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
    
    var hasMovedGreaterThanHalfway : Bool?
    switch(recognizer.state) {
      case .Began:
        if (currentState == .MenuCollapsed && gestureIsDraggingFromLeftToRight) {
          print("state began addMenuViewController \(selectedViewController!.view.bounds.size.width)")
          addMenuViewController()
        }
      case .Changed:
        break
      case .Ended:
        // animate the menu open or closed based on whether the view has moved more or less than halfway
        hasMovedGreaterThanHalfway = selectedViewController!.view.center.x > view.bounds.size.width
        animateMenuPanel(hasMovedGreaterThanHalfway!)
      case .Cancelled:
        break
      case .Failed:
        break
      case .Possible:
        break
    }
  }
  
}

// MARK: HamburgerViewController
extension ContainerViewController: HamburgerViewControllerDelegate {
  func showHomeTimeline(menu: HamburgerViewController) {
    homeViewController = UIStoryboard.homeViewController()
    selectViewController(homeViewController)
  }
  
  func showProfile(menu: HamburgerViewController) {
    profileViewController = UIStoryboard.profileViewController()
    selectViewController(profileViewController)
  }
  
  func showMentionsTimeline(menu: HamburgerViewController) {
    mentionsViewController = UIStoryboard.mentionsViewController()
    selectViewController(mentionsViewController)
  }
}


private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func homeViewController() -> HomeTableViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("HomeTableViewController") as? HomeTableViewController
  }
  
  class func mentionsViewController() -> MentionsTableViewController? {
     return mainStoryboard().instantiateViewControllerWithIdentifier("MentionsTableViewController") as? MentionsTableViewController
  }
  
  class func hamburgerViewController() -> HamburgerViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("HamburgerViewController") as? HamburgerViewController
  }
  
  class func profileViewController() -> ProfileViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
  }
  
}
