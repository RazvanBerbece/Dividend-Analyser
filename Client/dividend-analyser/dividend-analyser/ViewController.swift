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
    
    /* Managers */
    var firebaseClient : FirebaseClient?
    
    /* Initialising the State Handler */
    var handle : AuthStateDidChangeListenerHandle?
    
    /* User State to be sent through segue */
    var authResult : AuthDataResult?
    
    /* Button Action Functions */
    @IBAction func signUp(sender: UIButton) {
        
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
    
    @IBAction func signIn() {
        
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
        
        /* Adding the gradient overlay to the main view */
        //        let gradient = CAGradientLayer()
        //        gradient.frame = view.bounds
        //        gradient.colors = [UIColor.white.cgColor, UIColor.gray.cgColor]
        //        self.view.layer.insertSublayer(gradient, at: 0)
        
        /* Handler for Firebase functionality */
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // User data can be handled here
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /* Removing the Firebase handler */
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        /* This can be empty, presence required */
    }
    
}

