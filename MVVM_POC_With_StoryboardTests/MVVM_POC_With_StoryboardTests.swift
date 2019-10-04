//
//  MVVM_POC_With_StoryboardTests.swift
//  MVVM_POC_With_StoryboardTests
//
//  Created by sawant kumar on 03/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import XCTest
@testable import MVVM_POC_With_Storyboard

class MVVM_POC_With_StoryboardTests: XCTestCase {
    
    let viewModel = UserViewModel()

    override func setUp() {
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        //1. Username and password are required..
         viewModel.updateUserName(userName: "Sawa@gmail.com")
         viewModel.updatePassword(password: "")
         
        var errorMessage = viewModel.validate()
         print(errorMessage)
         XCTAssertEqual(errorMessage, "Username and password are required.")
        
        //2. UserName needs to be atleast 4 characters.
        viewModel.updateUserName(userName: "Saw")
        viewModel.updatePassword(password: "Test1234")
        
        errorMessage = viewModel.validate()
        print(errorMessage)
        XCTAssertEqual(errorMessage, "UserName needs to be atleast 4 characters.")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
