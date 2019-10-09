//
//  Router.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 6/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//


import UIKit


protocol Router {
  
  var navigationController: UINavigationController { get }
  var rootViewController: UIViewController? { get }
  func present(_ module: Showable, animated: Bool)
  func push(_ module: Showable, animated: Bool, completion: (() -> Void)?)
  func pop(animated: Bool)
  
}
