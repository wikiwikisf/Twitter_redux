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
    newButton.action = Selector("createNewTweet")
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
  
  internal func createNewTweet() {
    // TODO
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
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
