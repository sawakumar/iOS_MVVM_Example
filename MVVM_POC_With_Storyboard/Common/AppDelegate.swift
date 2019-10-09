//
//  AppDelegate.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 03/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?
    
    var shortcutItem: UIApplicationShortcutItem?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
           let applicationCoordinator = ApplicationCoordinator(window: window) // 2

        self.window = window
           applicationCoordinator.start()  // 3
        
        var performShortcutDelegate = true
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            print("Application launched via shortcut")
            self.shortcutItem = shortcutItem
            
            performShortcutDelegate = false
        }
        
        return performShortcutDelegate
    }
    
    // This is to demonstrate deep linking with Application-Shortcut but the process remains same for all other flows like email verfication, push notification and all.
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {

        print("Application performActionForShortcutItem")
        completionHandler( handleShortcut(shortcutItem: shortcutItem) )
    }
    
    func handleShortcut( shortcutItem:UIApplicationShortcutItem ) -> Bool {
        print("Handling shortcut")
        var succeeded = false
        if( shortcutItem.type == "app.appshortcut.dashboard" ) {
            print("- Handling \(shortcutItem.type)")
            if let window = window {
                let coordinator = ApplicationCoordinator(window: window)
                coordinator.goTo(route: .Dashboard)
            }
            succeeded = true
        }
        else if( shortcutItem.type == "app.appshortcut.profile" ) {
               print("- Handling \(shortcutItem.type)")
               if let window = window {
                   let coordinator = ApplicationCoordinator(window: window)
                   coordinator.goTo(route: .Profile)
               }
               succeeded = true
        }
        return succeeded
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Application did become active")
        
        guard let shortcut = shortcutItem else { return }
        
        print("- Shortcut property has been set")
        
        _ = handleShortcut(shortcutItem: shortcut)
        
        self.shortcutItem = nil
        
    }


}

