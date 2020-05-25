//
//  ViewController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 10/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    /* IBOutlets and view components */
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passInput: UITextField!
    @IBOutlet weak var signupResultLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    var needsToSignUp : Bool?
    
    /* Managers */
    var firebaseClient : FirebaseClient?
    
    /* Initialising the State Handler */
    var handle : AuthStateDidChangeListenerHandle?
    
    /* User State to be sent through segue */
    var authResult : AuthDataResult?
    
    /* Button Action Functions as objc so they can be dynamically called in relation to needsToSignUp */
    @objc func signUp() {
        
        /* Getting Text Field values */
        let email = self.emailInput.text
        let pass = self.passInput.text
        
        /* Validating input */
        var inputChecked = false
        if email?.isEmpty == false && pass?.isEmpty == false {
            inputChecked = true
        }
        
        if inputChecked {
            /* Using Firebase Auth to sign up a new user */
            Auth.auth().createUser(withEmail: email!, password: pass!) {
                (authResult, error) in
                if error == nil {
                    print("Successfully created account with email : \(email!)")
                    
                    self.signupResultLabel.textColor = UIColor(ciColor: .green)
                    self.signupResultLabel.text = "Account successfully created !"
                    
                    /* Creating a default Firebase Database entry */
                    Auth.auth().signIn(withEmail: email!, password: pass!) {
                        (authResult, error) in
                        if error == nil {
                            self.firebaseClient = FirebaseClient(user: authResult!.user)
                            self.firebaseClient?.uploadTransactionToUser(transaction: [["Add Stocks to see them here !"]]) {
                                (result) in
                                if result == true {
                                    print("Default portofolio initialised for the signed-up user.")
                                }
                                else {
                                    print("Default portofolio not initialised.")
                                }
                            }
                        }
                    }
                    
                    /* Segue-ing to user screen */
                    self.performSegue(withIdentifier: "moveToUserScreen", sender: self)
                }
                else { // An error occured during sign-up
                    print("error = \(error!)")
                    
                    self.signupResultLabel.textColor = UIColor(ciColor: .red)
                    self.signupResultLabel.text = "Signup failed, please try again."
                }
            }
        }
        else {
            print("Input not valid. Review input and try again.")
            
            self.signupResultLabel.textColor = UIColor(ciColor: .red)
            self.signupResultLabel.text = "Input not valid. Review input and try again."
        }
        
    }
    
    @objc func signIn() {
        
        /* Getting Text Field values */
        let email = self.emailInput.text
        let pass = self.passInput.text
        
        /* Validating input */
        var inputChecked = false
        if email?.isEmpty == false && pass?.isEmpty == false {
            inputChecked = true
        }
        
        if inputChecked {
            /* Using Firebase Auth to sign in the user */
            Auth.auth().signIn(withEmail: email!, password: pass!) {
                [weak self] (authResult, error) in
                if error == nil {
                    /* User successfully logged in, sending view to UserScreen */
                    print("Successfully logged in user : \(String(describing: authResult?.user.email))")
                    self?.authResult = authResult
                    
                    DispatchQueue.main.async {
                        self?.emailInput.text = ""
                        self?.passInput.text = ""
                    }
                    
                    /* Moving to UserScreen */
                    self?.performSegue(withIdentifier: "moveToUserScreen", sender: self)
                }
                else {
                    /* Login failed */
                    print("Login failed : \(String(describing: error))")
                    
                    self?.signupResultLabel.text = "Email or password doesn't match any account."
                    self?.signupResultLabel.textColor = UIColor(ciColor: .red)
                }
            }
        }
        else {
            print("Input not valid. Review input and try again.")
            
            self.signupResultLabel.textColor = UIColor(ciColor: .red)
            self.signupResultLabel.text = "Input not valid. Review input and try again."
        }
        
    }
    
    /* Segue Performing Methodology */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "moveToUserScreen"){
            let userVC = segue.destination as! UserScreenController
            if let currentUser = Auth.auth().currentUser { // The user is logged in on the current session
                userVC.User = currentUser
                userVC.authResult = self.authResult!
                userVC.handle = self.handle
                userVC.FirebaseClient = FirebaseClient(user: Auth.auth().currentUser!)
            }
        }
    }
    
    override func viewDidLoad() {
        
        /* Setting the button action according to user's choice of either creating an account or connecting to one */
        if self.needsToSignUp == true { // user needs to create an account
            self.signUpButton.setTitle("Sign Up", for: .normal)
            
            /* Creating the tap gesture for the sign-up button */
            let signUpGR = UITapGestureRecognizer(target: self, action: #selector(ViewController.signUp))
            self.signUpButton.addGestureRecognizer(signUpGR)
        }
        else { // user needs to login
            self.signUpButton.setTitle("Login", for: .normal)
            
            /* Creating the tap gesture for the login button */
            let signUpGR = UITapGestureRecognizer(target: self, action: #selector(ViewController.signIn))
            self.signUpButton.addGestureRecognizer(signUpGR)
        }
        
        /* View Settings */
        self.signUpButton.layer.cornerRadius = 8.5
        
        super.viewDidLoad()
        
        /* Looks for single or multiple taps in order to dismiss the keyboard */
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        /* This can be empty, presence required */
    }
    
}

