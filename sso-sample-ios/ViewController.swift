//
//  ViewController.swift
//  sso-sample-ios
//
//  Created by Mathew Spolin on 5/4/16.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var safariViewController: SFSafariViewController?
    
    // the calling view can inject a closure for when login is completed
    var loginCompletion: () -> () = {}

    // the url that triggers the login form
    var ssoUrl = "http://test.appdirect.com/oauth/authorize?response_type=token&client_id=EQVRImsj0i"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use the notification center to detect when the login was successful
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(safariLogin(_:)), name: "closeSafariLoginView", object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginTapped(sender: AnyObject) {
        showLogin()
    }

    // create the SafariViewController and present it to the user
    
    func showLogin() {
        
        let authUrl = NSURL(string: ssoUrl)!
        
        safariViewController = SFSafariViewController(URL: authUrl)
        safariViewController!.delegate = self
        
        self.presentViewController(safariViewController!, animated: true, completion: nil)
    }
    
    // called when the controller is closed
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        // check to see if we have a valid session
        
        if loginWasSuccessful() {
            
            // call this view's dynamic closure
            
            self.loginCompletion()
            
        } else {
            
            // present the login form in a safari view controller
            
            self.presentViewController(safariViewController!, animated: true, completion: nil)
        }
    }
    
    // called via the web url scheme callback, from AppDelegate
    
    func safariLogin(notification: NSNotification) {
        
        let url = notification.object as! NSURL
        
        // this url will contain a token we can use to create our session
        // parse out the token we need here and use it to create the session
        
        //
        
        // finally, dismiss the login view
        
        self.safariViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // check to see if we have a session
    
    func loginWasSuccessful() -> Bool {
        
        // in this function we should confirm that the session is valid
        // or that we can create a valid session and return true or
        // false otherwise
        
        //
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // clean up our notification observer
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeSafariLoginView", object: nil)
    }

}

