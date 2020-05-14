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
    var authData: AuthDataResult?
    var handle: AuthStateDidChangeListenerHandle?
    
    /* IBActions and buttons events */
    @IBAction func submitChanges() {
        
        /* Variables which define what changes we have to submit to Firebase */
        var usernameUpdate = false, emailUpdate = false, passUpdate = false
        var madeChanges = false
        
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
                    madeChanges = true
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
                    madeChanges = true
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
                    madeChanges = true
                    
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
        
        /*
         if madeChanges {
         self.changesResultLabel.text = "Changes submitted successfully."
         self.changesResultLabel.textColor = UIColor(ciColor: .green)
         }
         else {
         self.changesResultLabel.text = "No changes submitted."
         self.changesResultLabel.textColor = UIColor(ciColor: .red)
         }
         */
        
    }
    
    override func viewDidLoad() {
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
    
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        /* This can be empty, presence required */
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
