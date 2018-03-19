//
//  NotificationsManager.swift
//  UserNotificationsExample
//
//  Created by Oscar Peredo on 2018/03/07.
//  Copyright © 2018 Fenrir. All rights reserved.
//

import UIKit

import UserNotifications

enum NotificationActions: String {
    case Perform = "PerformActionIdentifier"
    case OpenApp = "OpenAppActionIdentifier"
    case Authorization = "AuthorizationActionIdentifier"
    case Destructive = "DestructiveActionIdentifier"
}

enum NotificationCategories: String {
    case All = "AllActionsCategoryIdentifier"
    case Two = "TwoActionsCategoryIdentifier"
}

class NotificationsManager: NSObject {
    
    static let shared = NotificationsManager()
    private override init() {
        super.init()
    }

    
    func requestAuthorization() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permissions granted!")
            } else {
                print("Notification permissions not granted!")
            }
        }
    }
    
    func setupNotifications() {
        
        
        // Define the available actions for your notifications
        
        let performAction = UNNotificationAction(identifier: NotificationActions.Perform.rawValue, title: "Perform Action", options: [])
        let openAppAction = UNNotificationAction(identifier: NotificationActions.OpenApp.rawValue, title: "Open App", options: [.foreground])
        let authorizeAction = UNNotificationAction(identifier: NotificationActions.Authorization.rawValue, title: "Authorization Required", options: [.authenticationRequired])
        let destructiveAction = UNNotificationAction(identifier: NotificationActions.Destructive.rawValue, title: "Destructive Action", options: [.destructive])
        
        
        // Define the notification categories
        
        let categoryWithAllActions = UNNotificationCategory(identifier: NotificationCategories.All.rawValue,
                                                            actions: [performAction,openAppAction,authorizeAction,destructiveAction],
                                                            intentIdentifiers: [],
                                                            options: [])
        
        let categoryWithTwoActions = UNNotificationCategory(identifier: NotificationCategories.Two.rawValue,
                                                            actions: [performAction,destructiveAction],
                                                            intentIdentifiers: [],
                                                            options: [])
        
        
        // Register the categories that your app can handle, everytime this method is called previously registered categories are removed
        
        UNUserNotificationCenter.current().setNotificationCategories([categoryWithAllActions, categoryWithTwoActions])
    }
    
    
    func scheduleLocalNotification(withCategory category : NotificationCategories) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            switch settings.authorizationStatus {
            case .notDetermined:
            
                print("Notification permissions not determined!")
            
                break
            case .denied:
            
                print("Notification permissions not granted!")
            
                break
            case.authorized:
                
                switch category {
                case .All:
                    self.generateLocalNotification()
                    break
                case .Two:
                    self.generateLocalNotificationAlternative()
                }
            
                break
            }
        }
    }
    
    
    private func generateLocalNotification() {
        
        print("Generating a local notification with all types...")
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "All actions"
        notificationContent.body = "Shows all the action opion types and their effects. The options can be combined but they are not shown here."
        notificationContent.categoryIdentifier = NotificationCategories.All.rawValue
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let notificationIdentifier = "NotificationAllIdentifier"
        
        let notificationRequest = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            
            guard error == nil else {
                
                print(error!)
                
                return;
            }
            
            print("Notification scheduled to be fired on: \(String(describing: notificationTrigger.nextTriggerDate()))")
            
        }
    }
    
    private func generateLocalNotificationAlternative() {
        
        print("Generating a local notification with two types...")
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Two actions"
        notificationContent.body = "Illustrates how the category can be used to define the available actions for the user (2 in this case)."
        notificationContent.categoryIdentifier = NotificationCategories.Two.rawValue
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let notificationIdentifier = "NotificationTwoIdentifier"
        
        let notificationRequest = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            
            guard error == nil else {
                
                print(error!)
                
                return;
            }
            
            print("Notification scheduled to be fired on: \(String(describing: notificationTrigger.nextTriggerDate()))")
            
        }
    }
}

extension NotificationsManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // This method is only called when the app is in the foreground
        
        print("userNotificationCenter (willPresent)")
        
        CounterManager.shared.userNotificationCenterWillPresentCallCount += 1
        
        
        // Select how the user should be alerted
        completionHandler([.badge, .sound, .alert])
        
        // OR
        
        // Pass an empty dictionary if you don't want the system notification to be shown
        //         completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        print("userNotificationCenter (didReceive)")

        CounterManager.shared.userNotificationCenterDidReceiveCallCount += 1

        // Check which action identifier triggered the notification

        switch response.actionIdentifier {
        case NotificationActions.Perform.rawValue:
            print("-> Perform Action")
        case NotificationActions.OpenApp.rawValue:
            print("-> Open App Action")
        case NotificationActions.Authorization.rawValue:
            print("-> Authorization Action")
        case NotificationActions.Destructive.rawValue:
            print("-> Destructive Action")
        default:
            print("-> Undefined Action")
            break
        }

        // Always call the completion handler when the notification has been processed!
        completionHandler()
    }

    
}
