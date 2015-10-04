//
//  Tweet.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/3/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var user: User?
  var text: String?
  var createdAtString: String?
  var createdAt: NSDate?
  
  init(dictionary: NSDictionary) {
    user = User(dictionary: dictionary["user"] as! NSDictionary)
    text = dictionary["text"] as? String
    createdAtString = dictionary["created_at"] as? String
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    createdAt = formatter.dateFromString(createdAtString!)
  }
  
  internal static func assembleTweets(items: [NSDictionary]) -> [Tweet] {
    print("assembling tweets from \(items.count)")
    
    var tweets = [Tweet]()
    
    for item in items {
      let tweet = Tweet(dictionary: item)
      tweets.append(tweet)
    }
    
    return tweets
  }
}
