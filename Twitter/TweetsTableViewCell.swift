//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/18/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

protocol ReplyButtonCellDelegate: class {
    func onReplyButtonCellPress(cell: TweetsTableViewCell)
}

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    weak var delegate: ReplyButtonCellDelegate?
    
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.handleLabel.preferredMaxLayoutWidth = self.handleLabel.frame.size.width
        self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.handleLabel.preferredMaxLayoutWidth = self.handleLabel.frame.size.width
        self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width
    }
    
    @IBAction func onReply(sender: AnyObject) {
        delegate?.onReplyButtonCellPress(self)
    }
    
    @IBAction func favoriteButton(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteTweet(self.tweet!.id!, completion: { (tweet, error) -> () in
            if error != nil {
                println("favorite error: \(error)")
            } else {
                var favButton = sender as UIButton
                favButton.tintColor = UIColor.yellowColor()
            }
        })
    }
    
    @IBAction func retweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.reTweet(self.tweet!.id!, completion: { (tweet, error) -> () in
            if error != nil {
                println("retweet error: \(error)")
            } else {
                
            }
        })
    }

}
