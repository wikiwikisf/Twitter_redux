//
//  ProfileViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/10/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  var profileUser: User?
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var numberFollowersLabel: UILabel!
  @IBOutlet weak var numberFollowingLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var numberTweetsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // Setup data for the given user
    // or current user if the givenuser is nil
    setupUserProfile()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setupUserProfile() {
    profileUser = (profileUser == nil) ? User._currentUser : profileUser
    
    if let url = profileUser!.profileBannerURL {
      backgroundImageView.setImageWithURL(NSURL(string: url))
    }
    
    if let url = profileUser!.profileImageURL {
      profileImageView.setImageWithURL(NSURL(string: url))
    }
    
    screenNameLabel.text = "@\(profileUser!.screenName!)"
    nameLabel.text = profileUser!.name
    numberTweetsLabel.text = "\(profileUser!.tweetsCount!) Tweets"
    numberFollowersLabel.text = "\(profileUser!.followersCount!) Followers"
    numberFollowingLabel.text = "\(profileUser!.followingCount!) Following"
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
