//
//  SettingsScreenController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 11/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SettingsScreenController: UIViewController {
    
    /* IBOutlets */
    @IBOutlet weak var usernameInput : UITextField!
    @IBOutlet weak var emailInput : UITextField!
    @IBOutlet weak var passInput : UITextField!
    @IBOutlet weak var changesResultLabel: UILabel!
    
    /* View Side Variables */
    var User : User?
    
    /* Managers */
    var firebaseClient : FirebaseClient?
    
    /* IBActions and buttons events */
    @IBAction func submitChanges() {
        
        /* Variables which define what changes we have to submit to Firebase */
        var usernameUpdate = false, emailUpdate = false, passUpdate = false
        
        /* The values which have to be submitted to Firebase */
        var username : String?
        var email : String?
        var pass : String?
        
        /* Checking what changes should be made */
        if self.usernameInput.text?.count != 0 {
            usernameUpdate = true
            username = self.usernameInput.text
        }
        
        if self.passInput.text?.count != 0 {
            passUpdate = true
            pass = self.passInput.text
        }
        
        if self.emailInput.text?.count != 0 {
            emailUpdate = true
            email = self.emailInput.text
        }
        
        if usernameUpdate {
            /* Making the profile change request for the username */
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest!.displayName = username!
            changeRequest!.commitChanges { // Commiting the username change
                (error) in
                if error == nil {
                    print("Username changed successfully.")
                    
                    /* UI Updates */
                    self.changesResultLabel.text = "Username changed successfully."
                    self.changesResultLabel.textColor = UIColor(ciColor: .green)
                }
                else {
                    print("error = \(String(describing: error))")
                    /* UI Updates */
                    self.changesResultLabel.text = "An error occured"
                    self.changesResultLabel.textColor = UIColor(ciColor: .red)
                }
            }
        }
        
        /* Updating email address */
        if emailUpdate {
            Auth.auth().currentUser!.updateEmail(to: email!) {
                (error) in
                if error == nil {
                    print("Email changed successfully.")
                    
                    /* UI Updates */
                    self.changesResultLabel.text = "Email changed successfully."
                    self.changesResultLabel.textColor = UIColor(ciColor: .green)
                }
                else {
                    print("error = \(String(describing: error))")
                    
                    /* UI Updates */
                    self.changesResultLabel.text = "An error occured"
                    self.changesResultLabel.textColor = UIColor(ciColor: .red)
                }
            }
        }
        
        /* Updating password */
        if passUpdate {
            Auth.auth().currentUser!.updatePassword(to: pass!) {
                (error) in
                if error == nil {
                    print("Password changed successfully.")
                    
                    self.changesResultLabel.text = "Password changed successfully."
                    self.changesResultLabel.textColor = UIColor(ciColor: .green)
                }
                else {
                    print("error = \(String(describing: error))")
                    
                    self.changesResultLabel.text = "An error occured"
                    self.changesResultLabel.textColor = UIColor(ciColor: .red)
                }
            }
        }
    }
    
    /* Deletes current user from Firebase and signs out */
    @IBAction func deleteCurrentUser() {
        
        /* Displays an alert to make sure that the user wants to delete their account */
        let alert = UIAlertController(title: "Are you sure you want to delete your account ?", message: "By deleting your account, all your data will be erased from the system.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { // if the user chooses Yes, process the deletion
            _ in
            self.firebaseClient?.deleteUserData {
                (result) in
                if result {
                    // Signing out and moving to Root
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                }
                else {
                    self.changesResultLabel.text = "An error occured while deleting your account data."
                    self.changesResultLabel.textColor = UIColor(ciColor: .red)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { // else close
            _ in
            print("Account deletion interrupted.")
        }))
        
        self.present(alert, animated: true)
        
    }
    
    override func viewDidLoad() {
        
        /* Drawing a Horizontal Line under modal header */
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 15, y: 125))
        path.addLine(to: CGPoint(x: 360, y: 125))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
        
        super.viewDidLoad()
        
        self.firebaseClient = FirebaseClient(user: self.User!)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
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
