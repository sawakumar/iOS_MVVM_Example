//
//  ApplicationCoordinator.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 6/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

enum Route {
    case Login
    case Dashboard
    case Profile
}

class ApplicationCoordinator: Coordinator {
  let window: UIWindow
  let rootViewController: UINavigationController
  let router: AppRouter
  
  init(window: UIWindow) {
    self.window = window
    rootViewController = UINavigationController()
    rootViewController.navigationBar.prefersLargeTitles = true
    router = AppRouter(navigationController: rootViewController)
  }
    
func start() {
     window.rootViewController = router.toShowable()
     goTo(route: .Login)
     window.makeKeyAndVisible()
 }
    
 func goTo(route: Route) {
     switch route {
     case .Login:
        //Routing with Coordinator
        let loginCoordinator = LoginCoordinator(presenter: router)
        loginCoordinator.start()
     case .Dashboard:
        //Routing without coordinator.
         let vc = DashboardViewController(nibName: nil, bundle: nil)
         rootViewController.show(vc, sender: self)
     case .Profile:
        //Routing with Coordinator
        let profileCoordinator = ProfileCoordinator(presenter: router)
        profileCoordinator.start()
     }
     refreshWindow()
 }
        
 // This is where the magic happens
 private func refreshWindow() {
     window.rootViewController = rootViewController
     window.makeKeyAndVisible()
 }
    
}
