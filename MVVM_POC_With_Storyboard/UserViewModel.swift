//
//  passwordViewModel.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 03/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import Foundation

class UserViewModel {
    private let mininumUserNameLength = 4
    private let minimumPasswordLength = 8
    private var user = User()
    
    var userName: String {
        return user.name
    }
    
    var password: String {
        return user.password
    }
    
    var protectedUserName: String {
        if userName.count >= mininumUserNameLength {
            var displayName = [Character]()
            for (index, character) in userName.enumerated() {
                if index > userName.count - minimumPasswordLength {
                    displayName.append(character)
                }
                else {
                    displayName.append(contentsOf: "*")
                }
                
            }
            return String(displayName)
        }
        return userName
    }
    
    func validate() -> String {
        if user.name.isEmpty || user.password.isEmpty {
            return "Username and password are"
        }
        
        if user.name.count < mininumUserNameLength {
            return "UserName needs to be atleast 4 characters."
        }
        
        if user.password.count < minimumPasswordLength {
            return "Password needs to be atleast 8 characters."
        }
        return ""
    }
    
    func login() {
        startAccessCodeTimer()
    }
    
    
//    var accessCode: Int? {
//        didSet {
//            print("Access code: \(String(describing: accessCode))")
//        }
//    }
 
    //Data binding with box
    var accessCode: Box<Int?> = Box(nil)
}

// Variable updates
extension UserViewModel {
    func updateUserName(userName: String) {
        user.name = userName
    }
    
    func updatePassword(password: String) {
        user.password = password
    }
}

extension UserViewModel {
    func startAccessCodeTimer() {
        accessCode.value = Int.random(in: 100000..<990000)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self]  in
            self?.startAccessCodeTimer()
        }
    }
}
