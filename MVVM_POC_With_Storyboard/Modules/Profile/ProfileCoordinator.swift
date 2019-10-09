//
//  ProfileCoordinator.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 08/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator {

  private let presenter: Router
  private var profileViewController: ProfileViewController?
    
  init(presenter: Router) {
    self.presenter = presenter
  }

  func start() {
    let viewModel = UserViewModel()
    let vc = ProfileViewController(viewModel: viewModel)
    vc.title = "Profile"
    presenter.push(vc, animated: true, completion: nil)
    self.profileViewController = vc
  }
}
