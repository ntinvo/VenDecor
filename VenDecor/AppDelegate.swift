//
//  AppDelegate.swift
//  VenDecor
//
//  Created by Tin Vo on 3/10/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        

        
        // claim actions
        let claimAction = UIMutableUserNotificationAction()
        claimAction.identifier = "claimed"
        claimAction.title = "View"
        claimAction.activationMode = UIUserNotificationActivationMode.Foreground
        
        // claim category
        let claimCategory = UIMutableUserNotificationCategory()
        claimCategory.identifier = "claimed"
        
        // set default action
        let claimDefaultActions:NSArray = [claimAction]
        let claimMinimalActions:NSArray = [claimAction]
        claimCategory.setActions(claimDefaultActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        claimCategory.setActions(claimMinimalActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // message action
        let messageAction = UIMutableUserNotificationAction()
        messageAction.identifier = "message"
        messageAction.title = "View"
        messageAction.activationMode = UIUserNotificationActivationMode.Foreground
        
        // claim category
        let messageCategory = UIMutableUserNotificationCategory()
        messageCategory.identifier = "message"
        
        // set default action
        let messageDefaultActions:NSArray = [messageAction]
        let messageMinimalActions:NSArray = [messageAction]
        claimCategory.setActions(messageDefaultActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        claimCategory.setActions(messageMinimalActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)

        // NSSet of all our category
        let categories = NSSet(objects: claimCategory, messageCategory)
        
        // settings
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        
        return true
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

