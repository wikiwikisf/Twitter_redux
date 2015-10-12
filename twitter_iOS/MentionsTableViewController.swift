//
//  MentionsTableViewController.swift
//  twitter_iOS
//
//  Created by Vicki Chun on 10/10/15.
//  Copyright © 2015 Vicki Grospe. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {

  let tweetCellIdentifier = "TweetCell"
  
  var mentionTweets: [Tweet]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200

    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "renderMentionsTimeline", forControlEvents: UIControlEvents.ValueChanged)
    
    renderMentionsTimeline()
  }
  
  
  internal func renderMentionsTimeline() {
    TwitterClient.instance.getMentionsTimeline(["contributor_details":true]) { (tweets: [Tweet]?, error: NSError?) -> () in
      // If get home timeline successful then render the home tweets
      dispatch_async(dispatch_get_main_queue(), {
        if (tweets != nil) {
          self.mentionTweets = tweets
          self.tableView.reloadData()
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
    let rows = (mentionTweets != nil) ? mentionTweets.count : 0
    return rows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(tweetCellIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
    cell.tweet = mentionTweets[indexPath.row]
    cell.delegate = self
    return cell
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}

extension MentionsTableViewController : TweetTableViewCellDelegate {
  func tweetTableViewCell(cell: TweetTableViewCell, didTapProfileImage: UIImageView) {
    let screenName = cell.screenNameLabel
  }
  
  func tweetTableViewCell(cell : TweetTableViewCell, didChangeValue value: Bool) {
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
