//
//  DashboardViewController.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 07/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Data binding
        viewModel.dataSource.bind {[unowned self] _ in
            self.tableView.reloadData()
        }
    }
}

extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repo = viewModel.dataSource.value[indexPath.row]
        let description =  "\nDescription" + (repo.description ?? "")
        cell.textLabel?.text = (repo.name ?? "") + description
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}

//Data Binding
extension DashboardViewController {
    
}
