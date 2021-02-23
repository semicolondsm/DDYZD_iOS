//
//  AppDelegate.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/14.
//

import UIKit
import DSMSDK
import Firebase
import UserNotificationsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.backgroundColor = .white
        
        DSMSDKCommon.initSDK(clientID: "e20961403e0b43009c5dc070a8245e2e",
                             clientSecret: "b1336493014a4cef8a480712c2be4bcf",
                             redirectURL: "https://semicolondsm.xyz/")
        
        FirebaseApp.configure()
        
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in }
        )
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      completionHandler()
    }


}

