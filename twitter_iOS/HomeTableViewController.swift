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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Setup logout button in navigation bar
    let logoutButton = UIBarButtonItem()
    logoutButton.title = "Sign Out"
    logoutButton.action = Selector("logout")
    logoutButton.target = self
    navigationItem.leftBarButtonItem = logoutButton
    
    // Setup New button in navigation bar
    let newButton = UIBarButtonItem()
    newButton.title = "New"
    newButton.action = Selector("composeTweet")
    newButton.target = self
    navigationItem.rightBarButtonItem = newButton
    
    navigationItem.title = "Home"
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "renderHomeTimeline", forControlEvents: UIControlEvents.ValueChanged)
    
    // TODO: progress bar
    renderHomeTimeline()
  }
  
  internal func logout() {
    User.currentUser?.logout()
  }
  
  internal func composeTweet() {
    // segue to new tweet 
    performSegueWithIdentifier("newTweetSegue", sender: self)
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
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */
  
  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let cell = sender as? TweetTableViewCell {
      let indexPath = tableView.indexPathForCell(cell)!
      let currentTweet = homeTweets![indexPath.row]
      
      let navigationController = segue.destinationViewController as! UINavigationController
      let tweetDetailsViewController = navigationController.viewControllers[0] as! TweetTableViewController
      tweetDetailsViewController.currentTweet = currentTweet
    }
  }
  
}

extension HomeTableViewController : TweetTableViewCellDelegate {
  func tweetTableViewCell(cell : TweetTableViewCell, didChangeValue value: Bool?) {
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
