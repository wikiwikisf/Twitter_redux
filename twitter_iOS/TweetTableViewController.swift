//
//  TweetTableViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/4/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {
  
  let tweetCellIdentifier = "TweetCell"
  let countCellIdentifier = "CountCell"
  let actionCellIdentifier = "ActionCell"
  
  var currentTweet : Tweet!
  var numberOfRows : Int = 3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    // Setup home button in navigation bar
    let homeButton = UIBarButtonItem()
    homeButton.title = "Home"
    homeButton.action = Selector("returnHome")
    homeButton.target = self
    navigationItem.leftBarButtonItem = homeButton
    
    // Setup reply button in navigation bar
    let replyButton = UIBarButtonItem()
    replyButton.title = "Reply"
    replyButton.action = Selector("replyToTweet")
    replyButton.target = self
    navigationItem.rightBarButtonItem = replyButton
    
    navigationItem.title = "Tweet"
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 150
  }
  
  
  func replyToTweet() {
    performSegueWithIdentifier("replySegue", sender: self)
  }
  
  func returnHome() {
    dismissViewControllerAnimated(true, completion: nil)
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
    if (currentTweet.favoriteCount == 0 && currentTweet.retweetCount == 0) {
      numberOfRows = 2
      return numberOfRows
    } else {
      numberOfRows = 3
      return numberOfRows
    }
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    if indexPath.row == 0 {
      let tweetCell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
      tweetCell.tweet = currentTweet
      cell = tweetCell
    } else if indexPath.row == 1 && numberOfRows == 3 {
      // Render number of tweets and favorites if it exists.
      let countCell = tableView.dequeueReusableCellWithIdentifier(countCellIdentifier, forIndexPath: indexPath) as! CountTableViewCell
      countCell.tweet = currentTweet
      cell = countCell
    } else {
      // Render actions
      let actionCell = tableView.dequeueReusableCellWithIdentifier(actionCellIdentifier, forIndexPath: indexPath) as! ActionTableViewCell
      actionCell.tweet = currentTweet
      cell = actionCell
    }

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
      let navigationController = segue.destinationViewController as! UINavigationController
      let replyTweetViewController = navigationController.viewControllers[0] as! NewTweetViewController
      replyTweetViewController.replytweetId = currentTweet.id
  }
  
  
}
