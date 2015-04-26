//
//  AppDelegate.swift
//  TriumpSlack2
//
//  Created by Ali Ahmed on 4/17/15.
//  Copyright (c) 2015 Triumph labs. All rights reserved.
//

import UIKit
import Foundation
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINClientDelegate, PKPushRegistryDelegate {

    var window: UIWindow?
    var client: SINClient?
    var splash: UIImageView?
    
    func clientDidStart(client: SINClient) {
        NSLog("client did start")
    }
    
    func clientDidStop(client: SINClient) {
        NSLog("client did stop")
    }
    
    func clientDidFail(client: SINClient, error: NSError!) {
        NSLog("client did fail", error.description)
        let toast = UIAlertView(title: "Failed to start", message: error.description, delegate: nil, cancelButtonTitle: "OK")
        toast.show()
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();
        
        return true
    }
    
    func application(application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: NSError){
            println(error.localizedDescription)
            println("could not register: \(error)")
            
    }
    
    func application(application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
            
            /* Each byte in the data will be translated to its hex value like 0x01 or
            0xAB excluding the 0x part, so for 1 byte, we will need 2 characters to
            represent that byte, hence the * 2 */
            var tokenAsString = NSMutableString()
            
            /* Create a buffer of UInt8 values and then get the raw bytes
            of the device token into this buffer */
            var byteBuffer = [UInt8](count: deviceToken.length, repeatedValue: 0x00)
            deviceToken.getBytes(&byteBuffer)
            
            /* Now convert the bytes into their hex equivalent */
            for byte in byteBuffer{
                tokenAsString.appendFormat("%02hhX", byte)
            }
            
            println("Token = \(tokenAsString)")
            
    }
    
    func handleLocalNotification(notification: UILocalNotification) {
        if client != nil {
            let result: SINNotificationResult = client!.relayLocalNotification(notification)
            if result.isCall() && (result.callResult().isTimedOut) {
                let msg = "Missed call from " + result.callResult().remoteUserId
                let alert = UIAlertView()
                alert.title = "Missed call"
                alert.message = msg
                alert.show()
            }
        }
    }
    
    func createSinchClient(userId: String) {
        if client == nil {
            client = Sinch.clientWithApplicationKey("d103b10d-a308-43de-bf1c-73812dc25cc2", applicationSecret: "1KeguzZ3iU2jAkQYNIpWQg==", environmentHost: "sandbox.sinch.com", userId: userId)
            
            client!.setSupportCalling(true)
            client!.setSupportActiveConnectionInBackground(true)
            
            client!.delegate = self
            
            client!.start()
            client!.startListeningOnActiveConnection()
        }
    }
    
    func dismissSplashViewIfNecessary() {
        if self.splash != nil {
            window!.bringSubviewToFront(splash!)
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.TransitionNone,
                animations: { () -> Void in
                    self.splash!.alpha = 0.0
                },
                completion: { (Bool) -> Void in
                    self.splash!.removeFromSuperview()
            })
        }
    }
    
    func addSplashView() {
        self.splash = UIImageView(frame: CGRectMake(0, 0, 320, 480))
        splash!.image = UIImage(named: "Default")
        splash!.tag = 4321
        splash!.alpha = 1.0
        
        self.window!.addSubview(splash!)
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

