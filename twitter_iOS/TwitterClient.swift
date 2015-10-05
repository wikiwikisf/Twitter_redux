//
//  TwitterClient.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/3/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

let credentials = Credentials.defaultCredentials

struct Credentials {
  static let defaultCredentialsFile = "Credentials"
  static let defaultCredentials     = Credentials.loadFromPropertyListNamed(defaultCredentialsFile)
  
  let consumerKey: String
  let consumerSecret: String
  
  private static func loadFromPropertyListNamed(name: String) -> Credentials {
    let path           = NSBundle.mainBundle().pathForResource(name, ofType: "plist")!
    let dictionary     = NSDictionary(contentsOfFile: path)!
    let consumerKey    = dictionary["ConsumerKey"] as! String
    let consumerSecret = dictionary["ConsumerSecret"] as! String
    
    return Credentials(consumerKey: consumerKey, consumerSecret: consumerSecret)
  }
}

let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
  static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: credentials.consumerKey, consumerSecret: credentials.consumerSecret)
  
  // Callback when login is successful
  var loginCompletion: ((user: User?, error: NSError?) -> ())?
  
  func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
    loginCompletion = completion
    
    // Fetch request token and redirect to authorization url
    self.requestSerializer.removeAccessToken()
    fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
      print("Got request token")
      let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
      UIApplication.sharedApplication().openURL(authURL!)})
      {(error: NSError!) -> Void in
        print("Failed to get request token")
        self.loginCompletion?(user: nil, error: error)
    }
  }
  
  func openUrl(url: NSURL) {
    fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
      print("successfully retrieved access token")
      self.requestSerializer.saveAccessToken(accessToken)
      
      // TODO: move to function
      self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        print("user: \(response)")
        let user = User(dictionary: response as! NSDictionary)
        User.currentUser = user
        self.loginCompletion?(user: user, error: nil)
      }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        print("error getting current user")
        self.loginCompletion?(user: nil, error: error)
      }
    
      }) { (error: NSError!) -> Void in
        print("failed to get access token")
        self.loginCompletion?(user: nil, error: error)
    }
  }
  
  func getHomeTimeline(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
    GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      let dictionary = response as! [NSDictionary]
      print("received tweets ", dictionary.count)
      print("first tweet: \(response[0])")
      
      let tweets = Tweet.assembleTweets(response as! [NSDictionary])
      completion(tweets: tweets, error: nil)
      
      for tweet in tweets {
        print("text: \(tweet.text), isRetweet: \(tweet.retweeted), date: \(tweet.createdAt)")
      }
      
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        print("error getting the home timeline")
        completion(tweets: nil, error: error)
    })
  }
  
  func postTweet(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      print("post tweet successful \(response)")
      let dictionary = response as! NSDictionary
      let postedTweet = Tweet(dictionary: dictionary)
      completion(tweet: postedTweet, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        print("error posting tweet")
        completion(tweet: nil, error: error)
    })
  }
  
  

}
