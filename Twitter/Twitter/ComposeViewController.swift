//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Muin Momin on 2/27/16.
//  Copyright © 2016 Muin. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var tweetBox: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTweet(sender: AnyObject) {
        let t = tweetBox.text
        if (t.characters.count > 140 || t.characters.count == 0) {
            let alertController = UIAlertController(title: "Invalid tweet.", message: "The tweet is of invalid size.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {}
        }
        else {
            TwitterClient.sharedInstance.tweetWithCompleition(t, completion: { (error) -> () in
            
            })
            dismissViewControllerAnimated(true, completion: nil)
        }
        
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
