//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 3/1/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MentionCellDelegate {

    @IBOutlet weak var mentionsTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    let currentUser = User.currentUser
    var tweets: [Tweet]?
    let mentionTweetCellId = "mentionTweetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Mentions"
        
        self.mentionsTableView?.dataSource = self
        self.mentionsTableView?.delegate = self
        self.mentionsTableView?.estimatedRowHeight = 88.0
        self.mentionsTableView?.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = mentionsTableView
        dummyTableVC.refreshControl = refreshControl
        
        fetchTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = tweets {
            return (array.count > 20) ? 20 : array.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = mentionsTableView.dequeueReusableCellWithIdentifier(mentionTweetCellId, forIndexPath: indexPath) as MentionTableViewCell
        if let tweet = tweets?[indexPath.row] {
            cell.delegate = self
            cell.tweet = tweet
            if let user = tweet.user as User! {
            cell.nameLabel.text = currentUser!.name
                cell.handleLabel.text = "@\(currentUser!.screenname!)"
                cell.tweetBodyLabel.text = tweet.text
                cell.timestampLabel.text = tweet.timeAgo
                cell.retweetCountLabel.text = tweet.retweetCount > 0 ? String(tweet.retweetCount!) : ""
                cell.favoritesCountLabel.text = tweet.favoriteCount > 0 ? String(tweet.favoriteCount!) : ""
            
                if let imageUrl = user.profileImageUrlBigger {
                    let profileImgUrl = NSURL(string: imageUrl)
                    let placeholder = UIImage(named: "no_photo")
                    
                    let imageRequestSuccess = {
                        (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
                        cell.profileImageView.image = image;
                        cell.profileImageView.alpha = 0
                        cell.profileImageView.layer.cornerRadius = 4.0
                        cell.profileImageView.clipsToBounds = true
                        UIView.animateWithDuration(0.5, animations: {
                            cell.profileImageView.alpha = 1.0
                        })
                        
                        cell.profileImageView.setImageWithURL(profileImgUrl)
                    }
                    let imageRequestFailure = {
                        (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
                        NSLog("imageRequrestFailure")
                    }
                    
                    let urlRequest = NSURLRequest(URL: profileImgUrl!)
                    
                    cell.profileImageView.setImageWithURLRequest(urlRequest, placeholderImage: placeholder, success: imageRequestSuccess, failure: imageRequestFailure)
                }
            }
        }
        return cell
    }
    
    func onProfileImagePress(cell: MentionTableViewCell) {
        
    }
    
    private func fetchTweets() {
        TwitterClient.sharedInstance.mentionsTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if error != nil {
                println("Error fetching tweets: \(error)")
            } else {
                self.tweets = tweets
                self.mentionsTableView?.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            self.refreshControl.endRefreshing()
        })
    }
}
