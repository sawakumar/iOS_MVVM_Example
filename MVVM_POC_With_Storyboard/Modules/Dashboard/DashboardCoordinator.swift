//
//  AppRouter.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 6/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

class DashboardCoordinator: Coordinator {

  private let presenter: Router // 1
  private var dashboardViewController: DashboardViewController? // 2

  init(presenter: Router) {

    self.presenter = presenter
  }

  func start() {
    let vc = DashboardViewController(nibName: nil, bundle: nil)
    vc.title = "Git Repositories List"
    presenter.push(vc, animated: true, completion: nil)
    self.dashboardViewController = vc  // 8
  }
}
