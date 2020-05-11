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
    
    /* View Side Variables */
    var User : User?
    var authData: AuthDataResult?
    var handle: AuthStateDidChangeListenerHandle?
    
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
                }
                else {
                    print("error = \(String(describing: error))")
                }
            }
        }
        
        /* Updating email address */
        if emailUpdate {
            Auth.auth().currentUser!.updateEmail(to: email!) {
                (error) in
                if error == nil {
                    print("Email changed successfully.")
                }
                else {
                    print("error = \(String(describing: error))")
                }
            }
        }
        
        /* Updating password */
        if passUpdate {
            Auth.auth().currentUser!.updatePassword(to: pass!) {
                (error) in
                if error == nil {
                    print("Password changed successfully.")
                }
                else {
                    print("error = \(String(describing: error))")
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
