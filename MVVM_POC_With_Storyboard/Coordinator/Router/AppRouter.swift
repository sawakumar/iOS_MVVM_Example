//
//  AppRouter.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 6/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

class AppRouter: NSObject, Router {
  
  private var completions: [UIViewController : () -> Void]
  
  public var rootViewController: UIViewController? {
    return navigationController.viewControllers.first
  }
  
  public unowned let navigationController: UINavigationController
  
  public init(navigationController: UINavigationController) {
    
    self.navigationController = navigationController
    self.completions = [:]
    super.init()
    
  }
  
  public func toShowable() -> UIViewController {
    return navigationController
  }
  
  func present(_ module: Showable, animated: Bool) {
    navigationController.present(module.toShowable(), animated: animated, completion: nil)
  }
  
  func push(_ module: Showable, animated: Bool, completion: (() -> Void)?) {
    //avoid pushing navigation controllers
    let controller = module.toShowable()
    
    guard controller is UINavigationController == false else {
      return
    }
    
    if let completion = completion {
      completions[controller] = completion
    }
    
    navigationController.pushViewController(controller, animated: animated)
  }
  
  func pop(animated: Bool) {
    if let controller = navigationController.popViewController(animated: animated) {
      runCompletion(for: controller)
    }
  }
  
  fileprivate func runCompletion(for controller: UIViewController) {
    
    guard let completion = completions[controller] else {
      return
    }
    
    completion()
    completions.removeValue(forKey: controller)
    
  }
}
