//
//  User.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/3/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

let currentUserKey = "_currentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
  var name: String?
  var screenName: String?
  var profileImageURL: String?
  var tagline: String?
  var dictionary: NSDictionary
  
  static var _currentUser: User?
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    
    name = dictionary["name"] as? String
    screenName = dictionary["screen_name"] as? String
    profileImageURL = dictionary["profile_image_url"] as? String
    tagline = dictionary["description"] as? String
  }

  class var currentUser: User? {
    get {
      // If we just entered the app, set the user if it exists in storage
      if _currentUser == nil {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
          do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            _currentUser = User(dictionary: dictionary)
          } catch let error as NSError {
            print("error getting json object" + error.description)
          }
        }
      }
      return _currentUser
    }
    set(user) {
      _currentUser = user
      
      // Persist the current user
      if _currentUser != nil {
        do {
          let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions.PrettyPrinted)
          NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
        } catch let error as NSError {
          print("error getting json object" + error.description)
        }
      } else {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
      }
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
  
  internal func logout() {
    User.currentUser = nil
    TwitterClient.instance.requestSerializer.removeAccessToken()
    
    // send event
    NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
  }

}
