//
//  TweetTableViewCell.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/4/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

protocol TweetTableViewCellDelegate: class {
  func tweetTableViewCell(cell: TweetTableViewCell, didChangeValue value: Bool)
  func tweetTableViewCell(cell: TweetTableViewCell, didTapProfileImage: UIImageView)
  func replyToTweet(cell: TweetTableViewCell)
}

class TweetTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var retweetedImageView: UIImageView!
  @IBOutlet weak var retweetedByLabel: UILabel!
  
  @IBOutlet weak var retweetImageBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var retweetImageTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var retweetByTopConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  
  weak var delegate: TweetTableViewCellDelegate?
  
  var tweetId : Int?
  var isFavorited: Bool?
  var isRetweeted: Bool?

  var tweet: Tweet! {
    didSet {
      if let url = tweet.user?.profileImageURL {
        profileImageView.setImageWithURL(NSURL(string: url))
      }
      profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onProfileImageTap:"))
      
      userNameLabel.text = tweet.user?.name
      let screenNameText = tweet.user?.screenName
      screenNameLabel.text = "@\(screenNameText!)"
      tweetTextLabel.text = tweet.text
      dateLabel.text = formatTimeElapsed(tweet.createdAt!)
      
      
      retweetedImageView.hidden = !tweet.retweeted
      retweetedByLabel.hidden = !tweet.retweeted
      if tweet.retweeted {
        let username = tweet.user?.name
        retweetedByLabel.text = "\(username!) Retweeted"
        retweetImageBottomConstraint.constant = 8.0
        retweetImageTopConstraint.constant = 8.0
        retweetByTopConstraint.constant = 8.0
      } else {
        retweetImageBottomConstraint.constant = 0.0
        retweetImageTopConstraint.constant = 0.0
        retweetByTopConstraint.constant = 0.0
      }
      
      tweetId = tweet.id
      isFavorited = tweet.favorited
      isRetweeted = tweet.isRetweeted
      
      if isFavorited ?? true {
        self.favoriteButton.imageView?.image = UIImage(named: "favorite_on")
      }
      
      if isRetweeted ?? true {
        self.retweetButton.imageView?.image = UIImage(named: "retweet_on")
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
  
  func onProfileImageTap(sender: UITapGestureRecognizer) {
    print("profile image tapped!")
    delegate?.tweetTableViewCell(self, didTapProfileImage: profileImageView)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    profileImageView.layer.cornerRadius = 4
    profileImageView.clipsToBounds = true
  }
  
  @IBAction func replyAction(sender: AnyObject) {
    // send event to TweetTableViewController to tell it to segue
    self.delegate?.replyToTweet(self)
  }
  
  @IBAction func retweetAction(sender: AnyObject) {
    if isRetweeted! == false {
      TwitterClient.instance.reTweet(["id": tweetId!]) { (tweet, error) -> () in
        if error == nil {
          print("retweeted")
          self.retweetButton.imageView?.image = UIImage(named: "retweet_on")
          self.isRetweeted = true
          self.delegate?.tweetTableViewCell(self, didChangeValue: true)
        }
      }
    }
  }
  
  @IBAction func favoriteAction(sender: AnyObject) {
    if isFavorited! == true {
      TwitterClient.instance.unFavoriteTweet(["id": tweetId!]) { (tweet, error) -> () in
        if error == nil {
          print("unfavorited tweet")
          // TODO: decrement favorite count
          self.favoriteButton.imageView?.image = UIImage(named: "favorite")
          self.isFavorited = false
          self.delegate?.tweetTableViewCell(self, didChangeValue: true)
        }
      }
    } else {
      TwitterClient.instance.favoriteTweet(["id": tweetId!]) { (tweet, error) -> () in
        if error == nil {
          print("favorited tweet")
          
          // TODO: increment favorite count
          self.favoriteButton.imageView?.image = UIImage(named: "favorite_on")
          self.isFavorited = true
          self.delegate?.tweetTableViewCell(self, didChangeValue: true)
        }
      }
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
