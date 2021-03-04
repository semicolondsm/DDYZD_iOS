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
            completionHandler: { _, _ in
            }
        )
        
        application.registerForRemoteNotifications()
        AuthAPI().refreshToken().subscribe().dispose()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      completionHandler()
        if let clubID = response.notification.request.content.userInfo["club_id"] as? String{
            let mainStoryboard = UIStoryboard(name: "Club", bundle: nil)
            let clubDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClubDetailViewController") as! ClubDetailViewController
            clubDetailViewController.clubID = Int(clubID)!
            UIApplication.topViewController()?.navigationController?.navigationBar.topItem?.title = ""
            UIApplication.topViewController()?.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1)
            UIApplication.topViewController()?.navigationController?.pushViewController(clubDetailViewController, animated: true)
        }
    }
}
