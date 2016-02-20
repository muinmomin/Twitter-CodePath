//
//  TwitterClient.swift
//  Twitter
//
//  Created by Muin Momin on 2/13/16.
//  Copyright © 2016 Muin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let twitterConsumerKey = "y5RojxmnFCmFgJ7JKyPqyI1nw"
let twitterConsumerSecret = "E2BCx4goiPX7a0LPm5Qwu4LVtE8me6seLMS2jQ53iTnHvIBrCK"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: { (progress: NSProgress) -> Void in
            }, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting home timeline.")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got request token.")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("error")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func likeWithCompletion(id: String?, completion: (error: NSError?) -> ()) {
        POST("1.1/favorites/create.json?id=\(id!)", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("couldnt like")
                completion(error: error)
        })
        
    }
    
    func retweetWithCompletion(id: String?, completion: (error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id!).json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("couldnt retweet")
                completion(error: error)
        })
        
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got access token.")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: { (progress: NSProgress) -> Void in
                }, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    let user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("Error getting user.")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token.")
                self.loginCompletion?(user: nil, error: error)
        }
    }

}
