//
//  ProfileViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/10/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  var user_name: String?
  
  @IBOutlet weak var profileImageView: UIImageView!
  
  @IBOutlet weak var numberTweetsLabel: UILabel!
  
  @IBOutlet weak var screenNameLabel: UILabel!
  
  @IBOutlet weak var numberFollowersLabel: UILabel!
  
  @IBOutlet weak var numberFollowingLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // Setup data for the given user
    // or current user if the givenuser is nil
    
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
