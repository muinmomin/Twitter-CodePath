//
//  User.swift
//  Twitter
//
//  Created by Muin Momin on 2/13/16.
//  Copyright © 2016 Muin. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        
        get {
            do {
                if _currentUser == nil {
                    let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                    if data != nil {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    }
                }
            } catch (let error) {
                print(error)
            }
            return _currentUser
        }
        
        set (user) {
            _currentUser = user
            do {
                if _currentUser != nil {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions.PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } else {
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                }
                NSUserDefaults.standardUserDefaults().synchronize()
            } catch (let error) {
                print(error)
                assert(false)
            }
        }
    }
}
