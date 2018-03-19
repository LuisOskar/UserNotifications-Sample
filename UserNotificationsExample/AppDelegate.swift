//
//  AppDelegate.swift
//  UserNotificationsExample
//
//  Created by Oscar Peredo on 2018/03/07.
//  Copyright © 2018 Fenrir. All rights reserved.
//

import UIKit

import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let launchOptions = launchOptions,
            let userInfo = launchOptions[.remoteNotification] as? [AnyHashable: Any]
        {
            // App was launched through a notification
            CounterManager.shared.launchedFromNotification = true
            
            
            // Execute some code here...
        }
    
        
        // Register the app to use remote notifications (the result of this call has to be handled using the AppDelegate methods shown on the extension bellow)
        UIApplication.shared.registerForRemoteNotifications()

        
        // Using the UserNotifications framework:
        
        // Register the actions and categories for your notifications
        NotificationsManager.shared.setupNotifications()

        // The delegate MUST be set on the application "willFinishLaunchingWithOptions" or the "didFinishLaunchingWithOptions" methods
        UNUserNotificationCenter.current().delegate = NotificationsManager.shared

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

// MARK: - AppDelegate extension to handle Remote Notifications token.

extension AppDelegate {
    
    // Registration -----------
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Use this token on your server to send push notifications to this device
        print("device token Base64: \(deviceToken.base64EncodedString())")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("could not register token, error: \(error)")
        
    }
    
    
    // Receving -----------
    
    // Foreground notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

        print("didReceiveRemoteNotification")

        CounterManager.shared.didReceiveRemoteNotificationCallCount += 1

    }

    // Foreground / Background / Silent Notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print("didReceiveRemoteNotification (fetchCompletionHandler)")

        CounterManager.shared.didReceiveRemoteNotificationFetchCallCount += 1

        completionHandler(.newData)
    }
}

