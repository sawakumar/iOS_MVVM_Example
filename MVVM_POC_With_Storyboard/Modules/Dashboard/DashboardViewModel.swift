//
//  DashboardViewModel.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 09/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import Foundation

class DashboardViewModel {
    
    var dataSource: Box<[GitResponseModel]> = Box([])

    init() {
        ServicesManager.getGithubRepoList(completion: {[weak self] result in
            print(result)
            if let result = result.value {
                self?.dataSource.value = result
            }
        });
    }
}
