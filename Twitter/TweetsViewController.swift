//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/17/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReplyButtonCellDelegate {
    
    @IBOutlet weak var tweetView: UITableView!
    let tweetCellId = "tweetCellIdentifier"
    var refreshControl: UIRefreshControl!
    var tweets: [Tweet]?
    var replyTweet: Tweet?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.navigationController?.navigationBarHidden = false
        self.tweetView?.dataSource = self
        self.tweetView?.delegate = self
        self.tweetView?.estimatedRowHeight = 81.0
        self.tweetView?.rowHeight = UITableViewAutomaticDimension

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tweetView
        dummyTableVC.refreshControl = refreshControl
        
        fetchTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if error != nil {
                println("Error fetching tweets: \(error)")
            } else {
                self.tweets = tweets
                self.tweetView?.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tweetDetailSegue" {
            let cell = sender as UITableViewCell
            if let indexPath = tweetView.indexPathForCell(cell) {
                let tweetController = segue.destinationViewController as TweetDetailViewController
                tweetController.tweet = self.tweets![indexPath.row]
                tweetView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        if segue.identifier == "replySegue" {
            if let tweet = self.replyTweet {
                let nc = segue.destinationViewController as UINavigationController
                let composeController = nc.topViewController as TweetComposeViewController
                composeController.inReplyToTweet = tweet
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetView.dequeueReusableCellWithIdentifier(tweetCellId, forIndexPath: indexPath) as TweetsTableViewCell

        if let tweet = tweets?[indexPath.row] {
            cell.tweet = tweet
            cell.delegate = self
            if let user = tweet.user as User! {
                cell.nameLabel.text = user.name
                cell.handleLabel.text = "@\(user.screenname!)"
                cell.tweetLabel.text = tweet.text
                cell.timestampLabel.text = tweet.timeAgo
                cell.retweetCountLabel.text = tweet.retweetCount > 0 ? String(tweet.retweetCount!) : ""
                cell.favoriteCountLabel.text = tweet.favoriteCount > 0 ? String(tweet.favoriteCount!) : ""
                
                if let imageUrl = user.profileImageUrlBigger {
                    let profileImgUrl = NSURL(string: imageUrl)
                    let placeholder = UIImage(named: "no_photo")
                    
                    let imageRequestSuccess = {
                        (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
                        cell.userImage.image = image;
                        cell.userImage.alpha = 0
                        cell.userImage.layer.cornerRadius = 4.0
                        cell.userImage.clipsToBounds = true
                        UIView.animateWithDuration(0.5, animations: {
                            cell.userImage.alpha = 1.0
                        })
                        
                        cell.userImage.setImageWithURL(profileImgUrl)
                    }
                    let imageRequestFailure = {
                        (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
                        NSLog("imageRequrestFailure")
                    }
                    
                    let urlRequest = NSURLRequest(URL: profileImgUrl!)
                    
                    cell.userImage.setImageWithURLRequest(urlRequest, placeholderImage: placeholder, success: imageRequestSuccess, failure: imageRequestFailure)
                }
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = tweets {
            return (array.count > 20) ? 20 : array.count
        } else {
            return 0
        }
    }
    
    func onReplyButtonCellPress(cell: TweetsTableViewCell) {
        println("reply button clicked: \(cell.tweet?.id)")
        self.replyTweet = cell.tweet
    }
}
