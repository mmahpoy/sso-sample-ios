//
//  ViewController.swift
//  sso-sample-ios
//
//  Created by Mathew Spolin on 5/4/16.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import UIKit
import SafariServices

protocol SAMLViewControllerDelegate {
    func loginWasSccessful(userObject: UserObject)
}

class ViewController: UIViewController, SFSafariViewControllerDelegate, SAMLViewControllerDelegate {
    
    var safariViewController: SFSafariViewController?
    var userObject: UserObject?
    var delegate: SAMLViewControllerDelegate?
    
    // the calling view can inject a closure for when login is completed
    
    @IBOutlet weak var loginButton: UIButton!
    
    // the url that triggers the login form - this could be overriden by the value in NSUserDefaults set by an MDM server
    
//    var ssoUrl = "http://test.appdirect.com/oauth/authorize?response_type=token&client_id=EQVRImsj0i"
//    var ssoUrl = "http://172.20.5.68:8080/?redirect=sso-sample://return/"
//    var ssoUrl = "http://162.157.235.21:9090/account/2/saml/login?redirect=sso-sample://return/"
    var ssoUrl = "http://162.157.235.21:9090/account/2/saml/login/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use the notification center to detect when the login was successful
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(safariLogin(_:)), name: "closeSafariLoginView", object: nil)
        
        // fetch the url out of the prefs if it exists
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let value = defaults.stringForKey("login_url") {
            self.ssoUrl = value
        }
        
        self.delegate = self
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
        
        // present the login form in a safari view controller
        
        self.presentViewController(safariViewController!, animated: true, completion: nil)
    }
    
    // called when the controller is initialized
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
    }
    
    // called when the controller is closed
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        // <<<< REMOVE THIS TEST CODE
        // This will simulate a valid resonse from the server until the server is ready for real world testing
//        if let urlString = "http://172.20.5.68:8080/saml/login?user={\"password\":\"*********\",\"userName\":\"kaligan@gmail.com\",\"authorities\":[{\"authority\":\"ROLE_USER\"}]}".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) {
//            if let url = NSURL(string: urlString) {
//                NSNotificationCenter.defaultCenter().postNotificationName("closeSafariLoginView", object: url)
//            }
//        }
        // >>>>
        
        // check to see if we have a valid session
        
        if loginWasSuccessful() {
            
            // call this view's delegate's closure
            
            delegate?.loginWasSccessful(userObject!)
            
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
        
        userObject = UserObject.objectFromUrl(url.absoluteString)
        
        // check to see if we have a valid session
        
        if loginWasSuccessful() {
            
            // call this view's delegate's closure
            
            delegate?.loginWasSccessful(userObject!)
            
        } else {
            
            // The response URL was not properly formatted, we can't build an auth token
        }
        
        // finally, dismiss the login view
        
        self.safariViewController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // check to see if we have a session
    
    func loginWasSuccessful() -> Bool {
        
        // in this function we should confirm that the session is valid
        // or that we can create a valid session and return true or
        // false otherwise
        
        if userObject != nil {
            
            // We got a valid, properly formatted response from the server to build a token
            
            return true
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // clean up our notification observer
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeSafariLoginView", object: nil)
    }
    
    func loginWasSccessful(userObject: UserObject) {
        loginButton.titleLabel?.text = "You have logged in"
    }
}

