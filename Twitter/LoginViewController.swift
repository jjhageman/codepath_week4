//
//  ViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/16/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {(user: User?, error: NSError?) in
            if error != nil {
                println("Login error: \(error)")
            } else {
//                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//                let menuViewController = appDelegate.window!.rootViewController! as MenuViewController
//                let tvc = appDelegate.storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as TweetsViewController
//                menuViewController.activeViewController = tvc
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }

}

