//
//  CountsTableViewCell.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/4/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class CountTableViewCell: UITableViewCell {
  
  @IBOutlet weak var retweetCount: UILabel!
  @IBOutlet weak var favoriteCount: UILabel!
  
  @IBOutlet weak var retweetLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var favoriteLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var retweetBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var retweetTopConstraint: NSLayoutConstraint!
  
  var tweet: Tweet! {
    didSet {
      if let count = tweet.retweetCount {
        if (count == 0) {
          retweetCount.hidden = true
          retweetLeadingConstraint.constant = 0.0
          retweetBottomConstraint.constant = 0.0
          retweetTopConstraint.constant = 0.0
        } else {
          retweetCount.text = (count == 1) ? "1 Retweet" : "\(count) Retweets"
        }
      }
      
      if let count = tweet.favoriteCount {
        if (count == 0) {
          favoriteCount.hidden = true
        } else {
          favoriteCount.text = (count == 1) ? "1 Favorite" : "\(count) Favorites"
        }
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
