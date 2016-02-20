//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Muin Momin on 2/17/16.
//  Copyright © 2016 Muin. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            if let pic = tweet.user?.profileImageUrl {
                profilePic.setImageWithURL(NSURL(string: pic)!)
            }
            usernameLabel.text = "@ \((tweet.user?.screenname)!)"
            tweetTextLabel.text = tweet.text
            timestampLabel.text = tweet.createdAtString
            retweetCountLabel.text = "\(tweet.retweetsCount!)"
            likeCountLabel.text = "\(tweet.likesCount!)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletion(tweet.id!) { (error) -> () in
            if error == nil {
                self.retweetCountLabel.text = "\(Int(self.retweetCountLabel.text!)! + 1)"
            }
        }
    }

    @IBAction func onLike(sender: AnyObject) {
        TwitterClient.sharedInstance.likeWithCompletion(tweet.id!) { (error) -> () in
            if error == nil {
                self.likeCountLabel.text = "\(Int(self.likeCountLabel.text!)! + 1)"
            }
        }
    }


}
