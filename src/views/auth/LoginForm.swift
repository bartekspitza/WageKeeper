//
//  LoginForm.swift
//  WageKeeper
//
//  Created by Maikzy on 2019-02-12.
//  Copyright © 2019 Bartek . All rights reserved.
//

import Foundation
import UIKit
import Firebase
import PasswordTextField

class LoginForm: UIView {
    
    var emailField: UITextField!
    var passwordField: PasswordTextField!
    var mainBtn: SpinnerButton!
    var accessoryBtn: UIButton!
    var forgotPassBtn: UIButton!
    var errorLabel: UILabel!
    
    var errorLabelIsConfigured = false
    var mainBtnTitle: String!
    var FBButton: SpinnerButton!
    var loadingIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func showSuccessMessage(msg: String) {
        errorLabel.textColor = Colors.success
        errorLabel.text = msg
        errorLabel.layer.opacity = 1
        
        UIView.animate(withDuration: 2, delay: 1, options: [], animations: {
            self.errorLabel.layer.opacity = 0
        }, completion: {(true) in
                self.errorLabel.textColor = Colors.error
            self.errorLabel.text = ""
        })
    }
    
    func showErrorMessage(message: String) {
        if !errorLabelIsConfigured {
            self.configureErrorLabel()
            errorLabelIsConfigured = true
        }
        self.errorLabel.layer.opacity = 1
        self.errorLabel.text = message
        
    }
    
    func hideErrorMessage() {
        self.errorLabel.layer.opacity = 0
    }
    
    func configureErrorLabel() {
        errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        errorLabel.text = "Wrong password"
        errorLabel.textColor = Colors.error
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        errorLabel.center = CGPoint(x: self.center.x, y: passwordField.center.y + passwordField.frame.height/2 + 15)
        errorLabel.layer.opacity = 0
        
        self.addSubview(errorLabel)
    }
    
    func clear() {
        emailField.text = ""
        passwordField.text = ""
    }
    
    func create() {
        addEmailFieldToView()
        addPasswordFieldToView(y: emailField.center.y + emailField.frame.height + 10)
        addMainButton(title: "Log in", y: emailField.center.y + 120)
        addForgotPasswordButton()
        addAccessoryButton(title: "Create account")
        addFBButton()
        addLoadingIndicator()
    }
    func addLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .white
        loadingIndicator.center = CGPoint(x: self.center.x, y: self.frame.height/2 + mainBtn.center.y)
        self.addSubview(loadingIndicator)
    }
    func addFBButton() {
        FBButton = SpinnerButton(frame: CGRect(x: 0, y: 0, width: self.frame.width*0.75, height: 40), spinnerColor: UIColor.white)
        FBButton.button.backgroundColor = Colors.facebook
        FBButton.button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        FBButton.center = CGPoint(x: self.center.x, y: forgotPassBtn.frame.origin.y + forgotPassBtn.frame.height + 30 + FBButton.frame.height/2)
        FBButton.button.setTitleColor(.white, for: .normal)
        FBButton.setCornerRadius(radius: 10)
        FBButton.setTitle(title: "Sign in with facebook")
        FBButton.addFBLogo()
        
        self.addSubview(FBButton)
    }
    
    func addEmailFieldToView() {
        emailField = UITextField()
        emailField.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.75, height: 40)
        emailField.placeholder = "Email"
        emailField.textColor = .white
        emailField.font = UIFont.systemFont(ofSize: 14, weight: .light)
        emailField.autocapitalizationType = .none
        emailField.center = CGPoint(x: self.center.x, y: emailField.frame.height/2)
        emailField.keyboardType = .emailAddress
        emailField.autocorrectionType = .no
        emailField.addBottomBorder(color: .lightGray, width: 0.5)
        emailField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])

        self.addSubview(emailField)
    }
    
    
    func addPasswordFieldToView(y: CGFloat) {
        passwordField = PasswordTextField()
        passwordField.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.75, height: 40)
        passwordField.font = UIFont.systemFont(ofSize: 14, weight: .light)
        passwordField.textColor = .white
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .roundedRect
        passwordField.autocapitalizationType = .none
        passwordField.isSecureTextEntry = true
        passwordField.autocorrectionType = .no
        passwordField.center = self.center
        passwordField.center.y = y
        passwordField.imageTintColor = UIColor.white.withAlphaComponent(0.7)
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        passwordField.addBottomBorder(color: .lightGray, width: 0.5)
        
        self.addSubview(passwordField)
    }
    func addMainButton(title: String, y: CGFloat) {
        mainBtn = SpinnerButton(frame: CGRect(x: 50, y: 50, width: self.frame.width*0.75, height: 40), spinnerColor: UIColor.white)
        mainBtn.button.backgroundColor = Colors.theme
        mainBtn.button.tintColor = .white
        mainBtn.button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        mainBtn.center = CGPoint(x: self.center.x, y: y)
        mainBtn.setCornerRadius(radius: 10)
        mainBtn.setTitle(title: title)
        
        self.addSubview(mainBtn)
    }
    func addForgotPasswordButton() {
        forgotPassBtn = UIButton(type: .system)
        forgotPassBtn.setTitle("Forgot your password?", for: .normal)
        forgotPassBtn.setTitleColor(.white, for: .normal)
        forgotPassBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        forgotPassBtn.sizeToFit()
        forgotPassBtn.center = CGPoint(x: self.center.x, y: mainBtn.center.y + mainBtn.frame.height/2 + forgotPassBtn.frame.height/2 + 5)

        self.addSubview(forgotPassBtn)
    }
    func addAccessoryButton(title: String) {
        accessoryBtn = UIButton(type: .system)
        accessoryBtn.setTitle(title, for: .normal)
        accessoryBtn.setTitleColor(.white, for: .normal)
        accessoryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        accessoryBtn.sizeToFit()
        accessoryBtn.center = CGPoint(x: self.center.x, y: self.frame.height * 0.9)

        self.addSubview(accessoryBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
