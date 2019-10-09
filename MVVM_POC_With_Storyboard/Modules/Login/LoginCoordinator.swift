//
//  AppRouter.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 6/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

class LoginCoordinator: Coordinator {
  private let presenter: Router
  private var viewController: LoginViewController?
  private var dashboardCoordinator: DashboardCoordinator?
  
  init(presenter: AppRouter) {
    self.presenter = presenter
  }
  
  func start() {
    let vc = LoginViewController(user: User())
    vc.delegate = self
    vc.title = "Login"
    presenter.push(vc, animated: true, completion: nil)
    viewController = vc
  }
}

extension LoginCoordinator: LoginViewControllerDelegate {
    func viewControllerDidSelect(_ action: Action) {
        if action == .login {
            let vc = DashboardCoordinator(presenter: presenter)
               vc.start()
               self.dashboardCoordinator = vc
        }
        else if action == .forgotPassword {
            let vc = ProfileCoordinator(presenter: presenter)
            vc.start()
        }
    }
}
