//
//  ViewController.swift
//  Twitter
//
//  Created by Muin Momin on 2/13/16.
//  Copyright © 2016 Muin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogin() {
        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else {
                // handle login error
            }
        }
        
        
        
        
    }
}

