//
//  UpdateForm.swift
//  WageKeeper
//
//  Created by Maikzy on 2019-02-12.
//  Copyright © 2019 Bartek . All rights reserved.
//

import Foundation
import UIKit
import Firebase
import PasswordTextField

class UpdateForm: UIView {
    
    var field1: UITextField!
    var field2: UITextField!
    var passwordField: PasswordTextField!
    var formButton: SpinnerButton!
    var backButton: UIButton!
    var errorLabel: UILabel!
    
    var errorLabelIsConfigured = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func showErrorMessage(message: String) {
        if !errorLabelIsConfigured {
            self.configureErrorLabel()
            errorLabelIsConfigured = true
        }
        self.errorLabel.textColor = .red
        self.errorLabel.layer.opacity = 1
        self.errorLabel.text = message
        
    }
    
    func hideErrorMessage() {
        if errorLabelIsConfigured {
            self.errorLabel.layer.opacity = 0
        }
    }
    
    func configureErrorLabel() {
        errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        errorLabel.text = "Wrong password"
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        errorLabel.center = CGPoint(x: self.center.x, y: passwordField.center.y + passwordField.frame.height/2 + 15)
        errorLabel.layer.opacity = 0
        
        self.addSubview(errorLabel)
    }
    
    func clear() {
        field1.text = ""
        field2.text = ""
        passwordField.text = ""
    }
    
    func addField1(isEmailField: Bool) {
        field1 = UITextField()
        field1.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.75, height: 40)
        field1.font = UIFont.systemFont(ofSize: 14, weight: .light)
        field1.autocapitalizationType = .none
        field1.center = CGPoint(x: self.center.x, y: field1.frame.height/2)
        field1.autocorrectionType = .no
        field1.addBottomBorderWithColor(color: .lightGray, width: 0.5)
        
        if isEmailField {
            field1.placeholder = "New email"
            field1.keyboardType = .emailAddress
        } else {
            field1.placeholder = "New password"
        }
        
        self.addSubview(field1)
    }
    
    
    func addField2(isEmailField: Bool) {
        field2 = UITextField()
        field2.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.75, height: 40)
        field2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        field2.autocapitalizationType = .none
        field2.autocorrectionType = .no
        field2.center = self.center
        field2.center.y = field1.center.y + field1.frame.height/2 + 30
        field2.addBottomBorderWithColor(color: .lightGray, width: 0.5)
        
        if isEmailField {
            field2.placeholder = "Confirm email"
            field2.keyboardType = .emailAddress
        } else {
            field2.placeholder = "Confirm password"
        }
        
        self.addSubview(field2)
    }
    func addPasswordField() {
        passwordField = PasswordTextField()
        passwordField.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.75, height: 40)
        passwordField.font = UIFont.systemFont(ofSize: 14, weight: .light)
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.center = self.center
        passwordField.center.y = field2.center.y + field2.frame.height/2 + 30
        passwordField.addBottomBorderWithColor(color: .lightGray, width: 0.5)
        passwordField.placeholder = "Old password"
        passwordField.isSecureTextEntry = true
        
        self.addSubview(passwordField)
    }
    func addFormButton(title: String) {
        formButton = SpinnerButton(frame: CGRect(x: 50, y: 50, width: self.frame.width*0.75, height: 40), spinnerColor: UIColor.white)
        formButton.button.backgroundColor = Colors.theme
        formButton.button.tintColor = .white
        formButton.button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        formButton.button.setTitleColor(.lightGray, for: .highlighted)
        formButton.center = CGPoint(x: self.center.x, y: passwordField.center.y + 80)
        formButton.setTitle(title: title)
        formButton.setCornerRadius(radius: 10)
        
        self.addSubview(formButton)
    }
    
    func addBackButton() {
        backButton = UIButton()
        backButton.setTitle("Cancel", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        backButton.sizeToFit()
        backButton.center.x = self.center.x
        backButton.frame.origin.y = formButton.frame.origin.y + formButton.frame.height
        backButton.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .highlighted)
        self.addSubview(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
