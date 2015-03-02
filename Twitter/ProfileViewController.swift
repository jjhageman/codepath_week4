//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 3/1/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileBgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileTweetsView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    let currentUser = User.currentUser
    var tweets: [Tweet]?
    let profileTweetCellId = "profileTweetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Me"
        
        self.profileTweetsView?.dataSource = self
        self.profileTweetsView?.estimatedRowHeight = 88.0
        self.profileTweetsView?.rowHeight = UITableViewAutomaticDimension

        if let user = currentUser {
            nameLabel.text = user.name
            handleLabel.text = "@\(user.screenname!)"
            profileBgView.layer.cornerRadius = 4.0
            profileBgView.clipsToBounds = true
            
            let profileImgUrl = NSURL(string: user.profileImageUrlBigger!)
            let bannerImgUrl = NSURL(string: user.bannerImageUrl!)
            let placeholder = UIImage(named: "no_photo")
            
            let profileImageRequestSuccess = {
                (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
                self.profileImage.image = image;
                self.profileImage.alpha = 0
                self.profileImage.layer.cornerRadius = 4.0
                self.profileImage.clipsToBounds = true
                UIView.animateWithDuration(0.5, animations: {
                    self.profileImage.alpha = 1.0
                })
                
                self.profileImage.setImageWithURL(profileImgUrl)
            }
            let imageRequestFailure = {
                (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
                NSLog("imageRequrestFailure: \(error)")
            }
            
            let profileUrlRequest = NSURLRequest(URL: profileImgUrl!)
            
            profileImage.setImageWithURLRequest(profileUrlRequest, placeholderImage: placeholder, success: profileImageRequestSuccess, failure: imageRequestFailure)
            
            let bannerUrlRequest = NSURLRequest(URL: bannerImgUrl!)
            let bannerImageRequestSuccess = {
                (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
                self.bannerImage.image = image;
                self.bannerImage.alpha = 0
                UIView.animateWithDuration(0.5, animations: {
                    self.bannerImage.alpha = 1.0
                })
                
                self.profileImage.setImageWithURL(profileImgUrl)
            }
            
            bannerImage.setImageWithURLRequest(bannerUrlRequest, placeholderImage: placeholder, success: bannerImageRequestSuccess, failure: imageRequestFailure)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = profileTweetsView
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
        let cell = profileTweetsView.dequeueReusableCellWithIdentifier(profileTweetCellId, forIndexPath: indexPath) as ProfileTableViewCell
        if let tweet = tweets?[indexPath.row] {
            cell.tweet = tweet
            cell.nameLabel.text = currentUser!.name
            cell.handleLabel.text = "@\(currentUser!.screenname!)"
            cell.tweetBodyLabel.text = tweet.text
            cell.timestampLabel.text = tweet.timeAgo
            cell.retweetCountLabel.text = tweet.retweetCount > 0 ? String(tweet.retweetCount!) : ""
            cell.favoriteCountLabel.text = tweet.favoriteCount > 0 ? String(tweet.favoriteCount!) : ""
            cell.profileImageView.image = self.profileImage.image
            cell.profileImageView.layer.cornerRadius = 4.0
            cell.profileImageView.clipsToBounds = true
        }
        return cell
    }
    
    private func fetchTweets() {
        TwitterClient.sharedInstance.userTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if error != nil {
                println("Error fetching tweets: \(error)")
            } else {
                self.tweets = tweets
                self.profileTweetsView?.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            self.refreshControl.endRefreshing()
        })
    }
}
