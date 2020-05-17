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
    var transactions : [[String]] = []
    
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
        if let stocksSourceController = unwindSegue.source as? AddStocksController {
            self.transactions = stocksSourceController.portofolio
        }
        else if let portofolioController = unwindSegue.source as? UserPortofolioController {
            if portofolioController.dividendValue != 0 {
                self.amountLabel.text = "$\(portofolioController.dividendValue)"
            }
        }
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
            if Auth.auth().currentUser != nil {
                portofolioVC.portofolioDataFromFirebase = self.transactions
            }
        }
        else if segue.identifier == "moveToAddStocks" {
            let addStocksVC = segue.destination as! AddStocksController
            if Auth.auth().currentUser != nil {
                addStocksVC.portofolio = self.transactions
                addStocksVC.User = self.User!
            }
        }
    }
    
    /* Loads all the user required data from Firebase */
    func loadData() {
        
        if let userDisplay = User!.displayName { // User set up a username already
            self.userGreet.text = "Hello, \(String(describing: userDisplay))"
        }
        else { // else use their email for the user screen
            self.userGreet.text = "\(String(describing: User!.email!))"
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
