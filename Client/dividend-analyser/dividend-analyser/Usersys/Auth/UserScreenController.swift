//
//  UserScreenController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 11/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class UserScreenController: UIViewController {
    
    /* IBOutlets and view variables */
    @IBOutlet weak var userGreet: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    /* User Data Variables */
    var User : User?
    var authResult : AuthDataResult?
    var handle : AuthStateDidChangeListenerHandle?
    
    /* User Data Manager */
    var FirebaseClient : FirebaseClient?
    
    /* IBActions and button functions */
    @IBAction func signOut() {
        /* TODO ? */
        print("Trying to sign out ...")
    }
    
    @IBAction func settings() {
        /* Moving to SettingsScreen */
        self.performSegue(withIdentifier: "moveToSettings", sender: self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let userDisplay = User!.displayName {
            self.userGreet.text = "Hello, \(String(describing: userDisplay))"
            
            let transactions = ["\(String(describing: self.User!.displayName!))", "Login"]
             self.FirebaseClient?.uploadTransactionToUser(transaction: transactions) {
                 (result) in
                 if result == true {
                     print("Operation successful. (view)")
                 }
                 else {
                     print("Operation failed. (view)")
                 }
             }
        }
        else {
            self.userGreet.text = "Address: \(String(describing: User!.email!))"
            
            let transactions = ["\(String(describing: self.User!.uid))", "Login"]
             self.FirebaseClient?.uploadTransactionToUser(transaction: transactions) {
                 (result) in
                 if result == true {
                     print("Operation successful. (view)")
                 }
                 else {
                     print("Operation failed. (view)")
                 }
             }
        }
        
        /* ------------- DOWNLOAD DATA FROM FIREBASE DATABASE CALL -----------
        print(self.FirebaseClient!.downloadUserTransactions(completion: {
            (result) in
            if result.count > 0 {
                print("\(result[0]) (view)")
                self.amountLabel.text = result[0]
            }
            else {
                print("Nothing received from the download.")
            }
        }))
         */
        
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        /* This can be empty, presence required */
    }
    
    /* Segue Performing Methodology */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "moveToUserScreen"){
            let settingsVC = segue.destination as! SettingsScreenController
            if let currentUser = Auth.auth().currentUser { // The user is logged in on the current session
                settingsVC.User = currentUser
                settingsVC.authData = self.authResult!
                settingsVC.handle = self.handle!
            }
        }
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
