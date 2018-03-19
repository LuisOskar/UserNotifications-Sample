//
//  CounterManager.swift
//  UserNotificationsExample
//
//  Created by Oscar Peredo on 2018/03/12.
//  Copyright © 2018 Fenrir. All rights reserved.
//

import Foundation


class CounterManager {
    
    static let shared = CounterManager()
    private init() {}
    
    var launchedFromNotification = false
    
    
    var didReceiveRemoteNotificationCallCount = 0 {
        didSet {
            sendRefreshDisplayNotification()
        }
    }

    var didReceiveRemoteNotificationFetchCallCount = 0 {
        didSet {
            sendRefreshDisplayNotification()
        }
    }
    
    
    var userNotificationCenterDidReceiveCallCount = 0 {
        didSet {
            sendRefreshDisplayNotification()
        }
    }
    
    var userNotificationCenterWillPresentCallCount = 0 {
        didSet {
            sendRefreshDisplayNotification()
        }
    }
    
    
    func sendRefreshDisplayNotification () {
        
        let notif = Notification.init(name: NSNotification.Name(rawValue: "RefreshDisplay"))
        
        NotificationCenter.default.post(notif)
        
    }

}
