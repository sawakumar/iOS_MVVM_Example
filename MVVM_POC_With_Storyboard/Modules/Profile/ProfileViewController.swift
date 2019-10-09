//
//  ProfileViewController.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 08/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    private let viewModel: UserViewModel
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = viewModel.userName
    }
}
