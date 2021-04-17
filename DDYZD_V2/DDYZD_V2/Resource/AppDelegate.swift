//
//  AppDelegate.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/14.
//

import UIKit

import DSMSDK
import Firebase
import RxSwift
import UserNotificationsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window : UIWindow?
    var disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.backgroundColor = .white
        
        DSMSDKCommon.initSDK(clientID: "ab840667ddcd41dc81b29f8f128a0e66",
                             clientSecret: "adbf21db93f240a8a2d1e4e3b446689c",
                             redirectURL: "https://ddyzd.dsmkr.com/callback")
        
        FirebaseApp.configure()
        
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
            }
        )
        
        application.registerForRemoteNotifications()
        AuthAPI().refreshToken().subscribe().disposed(by: disposeBag)
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        AuthAPI().refreshToken().subscribe().disposed(by: disposeBag)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        disposeBag = DisposeBag()
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
    
    // FCM 클릭시 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let clubID = response.notification.request.content.userInfo["club_id"] as? String{
            let mainStoryboard = UIStoryboard(name: "Club", bundle: nil)
            let clubDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: "ClubDetailViewController") as! ClubDetailViewController
            clubDetailViewController.clubID = Int(clubID)!
            UIApplication.topViewController()?.navigationController?.navigationBar.topItem?.title = ""
            UIApplication.topViewController()?.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1)
            UIApplication.topViewController()?.navigationController?.pushViewController(clubDetailViewController, animated: true)
        } else if let roomID = response.notification.request.content.userInfo["room_id"] as? String {
            if let userType = response.notification.request.content.userInfo["user_type"] as? String {
                let mainStoryboard = UIStoryboard(name: "Chat", bundle: nil)
                let chatViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                chatViewController.roomID = Int(roomID)!
                chatViewController.userType = UserType(rawValue: userType)
                UIApplication.topViewController()?.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "xmark")
                UIApplication.topViewController()?.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "xmark")
                UIApplication.topViewController()?.navigationController?.navigationBar.topItem?.title = ""
                UIApplication.topViewController()?.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4811326265, green: 0.1003668979, blue: 0.812384963, alpha: 1)
                if SocketIOManager.shared.socketStatus == .connected {
                    UIApplication.topViewController()?.navigationController?.pushViewController(chatViewController, animated: true)
                } else {
                    AuthAPI().refreshToken().subscribe(onNext: { _ in
                        SocketIOManager.shared.establishConnection()
                        SocketIOManager.shared.on(.connect) { _,_ in
                            UIApplication.topViewController()?.navigationController?.pushViewController(chatViewController, animated: true)
                        }
                    }).disposed(by: disposeBag)
                }
            }
        }
        
        completionHandler()
    }
}
