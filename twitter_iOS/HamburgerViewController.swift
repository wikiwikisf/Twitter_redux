//
//  HamburgerViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/10/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

protocol HamburgerViewControllerDelegate : class {
  func showProfile(menu: HamburgerViewController)
  func showHomeTimeline(menu: HamburgerViewController)
  func showMentionsTimeline(menu: HamburgerViewController)
}


class HamburgerViewController: UIViewController {
  
  weak var delegate: HamburgerViewControllerDelegate?

  @IBOutlet weak var profileButton: UIButton!
  
  @IBOutlet weak var homeButton: UIButton!
  
  @IBAction func onClickProfile(sender: AnyObject) {
    print("clicked profile item")
    delegate?.showProfile(self)
  }
  
  @IBAction func onClickHome(sender: AnyObject) {
    print("clicked home menu item")
    delegate?.showHomeTimeline(self)
  }
  
  @IBAction func onClickMentions(sender: AnyObject) {
    print("clicked mentions menu item")
    delegate?.showMentionsTimeline(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let user = User.currentUser
    let userProfilePicUrl = user?.profileImageURL
    let data = NSData(contentsOfURL: NSURL(string: userProfilePicUrl!)!)
    profileButton.setImage(UIImage(data: data!), forState: UIControlState.Normal)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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