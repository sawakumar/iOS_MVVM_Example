//
//  Box.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 03/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listner = (T) -> Void
    var listner: Listner?
    
    var value: T {
        didSet{
            listner?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listner: Listner?) {
        self.listner = listner
        listner?(value)
    }
}
