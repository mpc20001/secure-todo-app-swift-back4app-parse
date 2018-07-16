//
//  ViewController.swift
//  AddingParseSDK
//
//  Created by Joren Winge on 12/8/17.
//  Copyright © 2017 Back4App. All rights reserved.
//

import UIKit
import Parse
class ViewController: BaseViewController {
    @IBOutlet fileprivate var signInUsernameField: UITextField!
    @IBOutlet fileprivate var signInPasswordField: UITextField!
    @IBOutlet fileprivate var signUpUsernameField: UITextField!
    @IBOutlet fileprivate var signUpPasswordField: UITextField!
    @IBOutlet fileprivate var forgotPasswordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInUsernameField.text = ""
        signInPasswordField.text = ""
        signUpUsernameField.text = ""
        signUpPasswordField.text = ""
    }

    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeScreen()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadHomeScreen(){
        ToDoController.sharedInstance.setUsersAclsNow()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        self.present(loggedInViewController, animated: true, completion: nil)
    }

    @IBAction func signIn(_ sender: UIButton) {
        validateSignIn()
    }

    @IBAction func signUp(_ sender: UIButton) {
        validateUser()
    }

    @IBAction func forgotPassword(_ sender: UIButton) {
        var emailText = ""
        if let email = forgotPasswordField.text{
            if !isValidEmail(testStr: email){
                displayErrorMessage(message: "Email does not seem to be an email")
                return
            }
            emailText = email.lowercased()
        }else{
            displayErrorMessage(message: "Email field is empty")
            return
        }
        beginResetProcessWith(email: emailText)
    }

    func beginResetProcessWith(email: String){
        showSpinner()
        PFUser.requestPasswordResetForEmail(inBackground: email) { (success, error) in
            self.hideSpinner()
            if success{
                self.completeReset()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: (descrip))
                }
            }
        }
    }

    func completeReset(){
        let alertView = UIAlertController(title: "Reset Complete!", message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }

    override func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }

    func validateSignIn(){
        var emailText = ""
        var passwordText = ""
        if let email = signInUsernameField.text{
            if !isValidEmail(testStr: email){
                displayErrorMessage(message: "Email does not seem to be an email")
                return
            }
            emailText = email.lowercased()
        }else{
            displayErrorMessage(message: "Email field is empty")
            return
        }

        if let password = signInPasswordField.text{
            passwordText = password
        }else{
            displayErrorMessage(message: "Password field is empty")
            return
        }
        beginSignInProcess(password: passwordText, email: emailText)
    }

    func beginSignInProcess(password: String, email: String){
        showSpinner()
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            self.hideSpinner()
            if user != nil {
                self.loadHomeScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: (descrip))
                }
            }
        }
    }

    func validateUser(){
        var emailText = ""
        var passwordText = ""
        if let email = signUpUsernameField.text{
            let formattedEmail = email.replacingOccurrences(of: " ", with: "")
            if !isValidEmail(testStr: formattedEmail){
                displayErrorMessage(message: "Email does not seem to be an email")
                return
            }
            emailText = formattedEmail.lowercased()
        }else{
            displayErrorMessage(message: "Email field is empty")
            return
        }

        if let password = signUpPasswordField.text{
            if(password.count < 5){
                displayErrorMessage(message: "Passwords must be at least 5 characters long!")
            }
            passwordText = password
        }else{
            displayErrorMessage(message: "Password field is empty")
            return
        }
        beginSignUpProcess(password: passwordText, email: emailText)
    }

    func beginSignUpProcess(password:String, email:String){
        let user = PFUser()
        user.username = email
        user.password = password
        user.email = email
        self.showSpinner()
        user.signUpInBackground { (success, error) in
            self.hideSpinner()
            if success{
                self.completeSignUp()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
    }

    func completeSignUp(){
        let alertView = UIAlertController(title: "Sign Up Complete!", message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            self.loadHomeScreen()
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }

}
