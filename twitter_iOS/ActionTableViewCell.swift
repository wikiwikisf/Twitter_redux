//
//  ActionsTableViewCell.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/4/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
  
  var tweetId : Int?
  var isFavorited: Bool?
  var isRetweeted: Bool?
  
  var tweet: Tweet! {
    didSet {
      tweetId = tweet.id
      isFavorited = tweet.favorited
      isRetweeted = tweet.isRetweeted
      
      if isFavorited == true {
        self.favoriteButton.imageView?.image = UIImage(named: "favorite_on")
      }
      
      if isRetweeted == true {
        self.retweetButton.imageView?.image = UIImage(named: "retweet_on")
      }
    }
  }

  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  
  @IBAction func replyAction(sender: AnyObject) {
    
  }
  
  @IBAction func favoriteAction(sender: AnyObject) {
    if isFavorited! == true {
      TwitterClient.instance.unFavoriteTweet(["id": tweetId!]) { (tweet, error) -> () in
        if error == nil {
          print("unfavorited tweet")
          // TODO: decrement favorite count
          self.favoriteButton.imageView?.image = UIImage(named: "favorite")
          self.isFavorited = false
        }
      }
    } else {
      TwitterClient.instance.favoriteTweet(["id": tweetId!]) { (tweet, error) -> () in
        if error == nil {
          print("favorited tweet")
          
          // TODO: increment favorite count
          self.favoriteButton.imageView?.image = UIImage(named: "favorite_on")
          self.isFavorited = true
        }
      }
    }
  }
  
  @IBAction func retweetAction(sender: AnyObject) {
    print("retweet action")
    if isRetweeted! == false {
      TwitterClient.instance.reTweet(["id": tweetId!]) { (tweet, error) -> () in
        if error == nil {
          print("retweeted")
          self.retweetButton.imageView?.image = UIImage(named: "retweet_on")
          self.isRetweeted = true
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
