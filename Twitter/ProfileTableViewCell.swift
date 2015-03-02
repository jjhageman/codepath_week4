//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Jeremy Hageman on 3/1/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.handleLabel.preferredMaxLayoutWidth = self.handleLabel.frame.size.width
        self.tweetBodyLabel.preferredMaxLayoutWidth = self.tweetBodyLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.handleLabel.preferredMaxLayoutWidth = self.handleLabel.frame.size.width
        self.tweetBodyLabel.preferredMaxLayoutWidth = self.tweetBodyLabel.frame.size.width
    }

}
