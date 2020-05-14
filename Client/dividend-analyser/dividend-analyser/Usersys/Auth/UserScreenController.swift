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
    var transactions : [[String]] = [[]]
    
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
        self.loadData()
        
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        /* This can be empty, presence required */
    }
    
    /* Segue Performing Methodology */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /* Should add segue-specific for Portofolio transactions */
        if(segue.identifier == "moveToUserScreen") {
            let settingsVC = segue.destination as! SettingsScreenController
            if let currentUser = Auth.auth().currentUser { // The user is logged in on the current session
                settingsVC.User = currentUser
                settingsVC.authData = self.authResult!
                settingsVC.handle = self.handle!
            }
        }
        else if segue.identifier == "moveToPortofolio" {
            let portofolioVC = segue.destination as! UserPortofolioController
            if let currentUser = Auth.auth().currentUser {
                portofolioVC.portofolioDataFromFirebase = self.transactions
            }
        }
        else if segue.identifier == "moveToAddStocks" {
            let addStocksVC = segue.destination as! AddStocksController
            if let currentUser = Auth.auth().currentUser {
                addStocksVC.portofolio = self.transactions
            }
        }
    }
    
    /* Loads all the user required data from Firebase */
    func loadData() {
        
        if let userDisplay = User!.displayName { // User set up a username
            self.userGreet.text = "Hello, \(String(describing: userDisplay))"
            
            let transactions = [["test", "test"], ["test1", "test1"]]
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
        else { // else use their email for the user screen
            self.userGreet.text = "Address: \(String(describing: User!.email!))"
            
            let transactions = [["test", "test"], ["test1", "test1"]]
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
        
        /* Download user portofolio data from Firebase Database */
        print(self.FirebaseClient!.downloadUserTransactions(completion: {
            (result) in
            if result.count > 0 {
                self.transactions = result
            }
            else {
                print("Nothing received from the download.")
            }
        }))
        
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
