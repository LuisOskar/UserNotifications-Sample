//
//  ViewController.swift
//  UserNotificationsExample
//
//  Created by Oscar Peredo on 2018/03/07.
//  Copyright © 2018 Fenrir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var launchedFromNotifLabel: UILabel!
    
    
    @IBOutlet weak var didReceiveCallCountLabel: UILabel!
    
    @IBOutlet weak var didReceiveFetchCallCountLabel: UILabel!
    
    
    @IBOutlet weak var userNotificationCenterDidReceive: UILabel!
    
    @IBOutlet weak var userNotificationCenterWillPresent: UILabel!
    
    var backgroundModeEnabled = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.refreshDisplay),
            name: NSNotification.Name(rawValue: "RefreshDisplay"),
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func requestPermissionButtonPressed(_ sender: UIButton) {
        
        NotificationsManager.shared.requestAuthorization()
        
    }
    
    
    @IBAction func scheduleNotificationButtonPressed(_ sender: UIButton) {
        
        NotificationsManager.shared.scheduleLocalNotification(withCategory: .All)
        
    }
    
    
    
    @IBAction func scheduleNotificationButtonTwoPressed(_ sender: UIButton) {
        
        NotificationsManager.shared.scheduleLocalNotification(withCategory: .Two)

    }
    
    @IBAction func enableBackgroundModePressed(_ sender: UIButton) {
        
        if backgroundModeEnabled
        {
            // Disable background mode
            backgroundModeEnabled = false
            
            GPSManager.shared.stopStandardUpdates()
            GPSManager.shared.disableBackgroundUpdates()
            
            sender.setTitle("Enable Background Mode", for: .normal)
        }
        else
        {
            // Enable background mode
            backgroundModeEnabled = true
            
            GPSManager.shared.startStandardUpdates()
            GPSManager.shared.enableBackgroundUpdates()
            
            sender.setTitle("Disable Background Mode", for: .normal)
        }
    }
    
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        CounterManager.shared.launchedFromNotification = false
        
        
        CounterManager.shared.didReceiveRemoteNotificationCallCount = 0

        CounterManager.shared.didReceiveRemoteNotificationFetchCallCount = 0
        
        
        CounterManager.shared.userNotificationCenterDidReceiveCallCount = 0
        
        CounterManager.shared.userNotificationCenterWillPresentCallCount = 0


        refreshDisplay()
    }
    
    @objc func refreshDisplay() {
        
        DispatchQueue.main.async {
        
            if CounterManager.shared.launchedFromNotification
            {
                self.launchedFromNotifLabel.text = "true"
                self.launchedFromNotifLabel.textColor = UIColor.red
            }
            else
            {
                self.launchedFromNotifLabel.text = "false"
                self.launchedFromNotifLabel.textColor = UIColor.black
            }
            
            self.didReceiveCallCountLabel.text = "\(CounterManager.shared.didReceiveRemoteNotificationCallCount)"
            
            self.didReceiveFetchCallCountLabel.text = "\(CounterManager.shared.didReceiveRemoteNotificationFetchCallCount)"
            
            
            self.userNotificationCenterDidReceive.text = "\(CounterManager.shared.userNotificationCenterDidReceiveCallCount)"
            
            self.userNotificationCenterWillPresent.text = "\(CounterManager.shared.userNotificationCenterWillPresentCallCount)"
        }
    }
    

}

