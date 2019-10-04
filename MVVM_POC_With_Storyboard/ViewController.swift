//
//  ViewController.swift
//  MVVM_POC_With_Storyboard
//
//  Created by sawant kumar on 03/10/19.
//  Copyright © 2019 sawant kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var viewHeaderLabel: UILabel!
    @IBOutlet weak var accessCodeLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    private var viewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewElements()
    }
    
    func bindViewElements() {
       viewModel.accessCode.bind { [unowned self] result in
            self.accessCodeLabel.text = "\(result ?? 0)"
        }
        
        
    }
    
    @IBAction func forgotPasswordButtonAction(sender: UIButton) {
      //TODO:-
    }
    
    @IBAction func continueButtonAction(sender: UIButton) {
        let errorMesage = viewModel.validate()
        print(errorMesage)
        
        //After validate call login
        view.endEditing(true)
        viewModel.login()
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userNameTextField {
            textField.text = viewModel.protectedUserName
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userNameTextField {
            viewModel.updateUserName(userName: textField.text!)
        }
        if textField == passwordTextField {
            viewModel.updatePassword(password:  textField.text!)
        }
        return true
    }
}

