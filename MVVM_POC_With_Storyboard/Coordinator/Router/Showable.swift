//
//  Showable.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 6/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

protocol Showable {
  
  func toShowable() -> UIViewController
}

extension UIViewController: Showable {
  public func toShowable() -> UIViewController {
    return self
  }
}
