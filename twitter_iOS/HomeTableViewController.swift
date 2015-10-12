//
//  HomeTableViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/3/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
  
  let tweetCellIdentifier = "TweetCell"
  
  var homeTweets: [Tweet]!
  private var profileUser: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "renderHomeTimeline", forControlEvents: UIControlEvents.ValueChanged)
    
    // TODO: progress bar
    renderHomeTimeline()
  }
    
  internal func renderHomeTimeline() {
    TwitterClient.instance.getHomeTimeline(["contributor_details":true]) { (tweets: [Tweet]?, error: NSError?) -> () in
      // If get home timeline successful then render the home tweets
      dispatch_async(dispatch_get_main_queue(), {
        if (tweets != nil) {
          self.homeTweets = tweets
          self.tableView.reloadData()
          self.refreshControl?.endRefreshing()
        } else {
          // Handle error
        }
      })
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let rows = (homeTweets != nil) ? homeTweets.count : 0
    return rows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
    cell.tweet = homeTweets[indexPath.row]
    cell.delegate = self
    return cell
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let cell = sender as? TweetTableViewCell {
      let indexPath = tableView.indexPathForCell(cell)!
      let currentTweet = homeTweets![indexPath.row]
      
      if let navigationController = segue.destinationViewController as? UINavigationController {
        let tweetDetailsViewController = navigationController.viewControllers[0] as! TweetTableViewController
        tweetDetailsViewController.currentTweet = currentTweet
      }
    } else if let navigationController = segue.destinationViewController as? UINavigationController {
      let profileVC = navigationController.viewControllers[0] as! ProfileViewController
      profileVC.profileUser = profileUser
    }
  }
}

extension HomeTableViewController : TweetTableViewCellDelegate {
  func tweetTableViewCell(cell: TweetTableViewCell, didTapProfileImage: UIImageView) {
    let screenName = cell.tweet.user?.screenName
    
    TwitterClient.instance.getUserWithScreenName(["screen_name": screenName!]) { (user: User?, error: NSError?) -> () in
      dispatch_async(dispatch_get_main_queue(), {
        if (error == nil) {
          self.profileUser = user
          self.performSegueWithIdentifier("showProfile", sender: self)
        }
      })
    }
  }
  
  func tweetTableViewCell(cell: TweetTableViewCell, didChangeValue value: Bool) {
    // here we update the favorited and retweeted status
    // find the tweet in [homeTweets" that matches the given cell.tweetId.
    // Update that tweet's favorited or retweeted icons
  }
  
  func replyToTweet(cell: TweetTableViewCell) {
    print("reply action using cell \(cell.tweetId)")
    // reply  using the given cell id to reply to
    //performSegueWithIdentifier("replySegue", sender: self)
    // in prepare to segue pass in the given tweet id
  }
  
}
