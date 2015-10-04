//
//  TweetTableViewCell.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/4/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var retweetedImageView: UIImageView!
  @IBOutlet weak var retweetedByLabel: UILabel!
  
  var tweet: Tweet! {
    didSet {
      if let url = tweet.user?.profileImageURL {
        profileImageView.setImageWithURL(NSURL(string: url))
      }
      userNameLabel.text = tweet.user?.name
      let screenNameText = tweet.user?.screenName
      screenNameLabel.text = "@\(screenNameText!)"
      tweetTextLabel.text = tweet.text
      dateLabel.text = formatTimeElapsed(tweet.createdAt!)
      
      if tweet.retweeted {
        retweetedImageView.hidden = false
        retweetedByLabel.hidden = false
        let username = tweet.user?.name
        retweetedByLabel.text = "\(username!) Retweeted"
      }
    }
  }
  
  internal func formatTimeElapsed(sinceDate: NSDate) -> String {
    let formatter = NSDateComponentsFormatter()
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
    formatter.collapsesLargestUnit = true
    formatter.maximumUnitCount = 1
    let interval = NSDate().timeIntervalSinceDate(sinceDate)
    return formatter.stringFromTimeInterval(interval)!
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    profileImageView.layer.cornerRadius = 4
    profileImageView.clipsToBounds = true
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
