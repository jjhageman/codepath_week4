//
//  MenuViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/26/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navTitleItem: UINavigationItem!
    
    @IBOutlet weak var tableConstraint: NSLayoutConstraint!
    
    var nc: UINavigationController?
    
    let menuCellId = "menuItemCell"
    let navigationItems = ["Timeline", "Mentions", "Me"]
    var viewControllers: [UIViewController] = []
    var cvc: TweetComposeViewController?
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var openMenuXPosition: CGFloat?
    var menuOriginalCenter: CGPoint?
    var menuHomePosition: CGPoint?
    
//    private var viewControllerArray: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        openMenuXPosition = screenSize.width + screenSize.width/2 - 50
        menuHomePosition = tableView.center
        
        self.navBar.barTintColor = UIColor(red: 0.299, green: 0.677, blue: 0.938, alpha: 1)
        self.navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
//        nc = self.storyboard?.instantiateViewControllerWithIdentifier("mainNC") as UINavigationController!
        
//        tweetViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TweetsViewController") as TweetsViewController!
//
//        pvc = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController!
//        
//        mvc = self.storyboard?.instantiateViewControllerWithIdentifier("MentionsViewController") as MentionsViewController!
        
//        if User.currentUser != nil {
//            nc!.pushViewController(tvc, animated: true)
//        }
//        viewControllers = [nc, nc, pvc]
//        activeViewController = nc
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.view.backgroundColor = UIColor(red: 0.299, green: 0.677, blue: 0.938, alpha: 1)
        setActiveViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onComposePress(sender: UIBarButtonItem) {
        activeViewController = cvc
    }
    
    @IBAction func onMenuPress(sender: UIBarButtonItem) {
        println("self.contentView.center: \(self.contentView.center), self.menuHomePosition!: \(self.menuHomePosition!)")
        if (self.contentView.center == self.menuHomePosition!) {
            showMenu()
        } else {
            closeMenu()
        }
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        panTweetView(sender)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navigationItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(self.menuCellId) as MenuViewCell
        cell.menuLabel!.text = navigationItems[indexPath.row] as String
        cell.backgroundColor = UIColor(red: 85/255.0, green:172/255.0, blue:238/255.0, alpha: 1)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        activeViewController = viewControllers[indexPath.row]
        closeMenu()
    }
    
//    var viewControllers: [UIViewController]  {
//        get { // getter returns read only copy
//            let immutableCopy = viewControllerArray
//            return immutableCopy
//        }
//        set {
//            viewControllerArray = newValue
//            
//            // set the active view controller to the first one in the new array if the current one is not in there
//            if activeViewController == nil || find(viewControllerArray, activeViewController!) == nil {
//                activeViewController = viewControllerArray.first
//            }
//        }
//    }
    
    var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            setActiveViewController()
        }
    }
    
    private func setActiveViewController() {
        if isViewLoaded() {
            if let activeVC = activeViewController {
                self.addChildViewController(activeVC)
                activeVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(activeVC.view)
                self.navTitleItem.title = activeVC.title
                activeVC.didMoveToParentViewController(self)
            }
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inactiveVC = inactiveViewController {
            inactiveVC.willMoveToParentViewController(nil)
            inactiveVC.view.removeFromSuperview()
            inactiveVC.removeFromParentViewController()
        }
    }
    
    private func closeMenu() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.contentView.center = self.menuHomePosition!}, completion: nil)
    }
    
    private func showMenu() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { self.contentView!.center = CGPoint(x: self.openMenuXPosition!, y: self.contentView!.center.y)
            }, completion: nil)
    }
    
    private func panTweetView(recognizer: UIPanGestureRecognizer) {
        var point = recognizer.locationInView(view)
        var velocity = recognizer.velocityInView(view)
        var translation = recognizer.translationInView(view)
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        
        switch(recognizer.state) {
        case .Began:
            menuOriginalCenter = contentView.center
        case .Changed:
            contentView.center = CGPoint(x: menuOriginalCenter!.x + translation.x, y: menuOriginalCenter!.y)
        case .Ended:
            let hasMovedGreaterThanHalfway = contentView.center.x > view.bounds.size.width
            if hasMovedGreaterThanHalfway {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.contentView.center = CGPoint(x: self.openMenuXPosition!, y: self.menuOriginalCenter!.y)
                    }, completion: nil)
            } else {
                if !gestureIsDraggingFromLeftToRight {
                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.contentView.center = self.menuHomePosition!
                        }, completion: nil)
                } else {
                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.contentView.center = self.menuOriginalCenter!
                        }, completion: nil)
                }
            }
        default:
            break
        }
    }
}
