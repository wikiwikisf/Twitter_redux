//
//  NewTweetView.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/4/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class NewTweetView: UIView {
  
  @IBOutlet weak var profilePicImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!  
  
  @IBOutlet weak var tweetTextField: UITextField!
  
  override func awakeFromNib() {
    profilePicImage.layer.cornerRadius = 4
    profilePicImage.clipsToBounds = true
    
    tweetTextField.becomeFirstResponder()
  }
  
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
  // Drawing code
  }
  */
  
}
