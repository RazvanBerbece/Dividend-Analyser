//
//  AddStocksController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 13/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddStocksController: UIViewController, UITextFieldDelegate {
    
    /* IBOutlets and View Variables */
    @IBOutlet weak var symbolInputLabel: UITextField! // Also used as a warning if no data is found for given stock symbol
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var predictionLabel: UILabel!
    
    /* User Variables */
    var portofolio : [[String]] = [] // this will be updated and sent
    var User : User?
    
    /* Current stock from API */
    var APIstock : [String] = []
    
    /* Managers */
    var firebaseClient : FirebaseClient?
    let predictor = SymbolHelper()
    
    /* IBActions and button functions */
    @IBAction func searchSymbol() {
        
        let symbolInput = self.symbolInputLabel.text // this will be passed to the API
        
        if symbolInput?.count == 0 {
            print("No input. Try searching for a stock symbol.")
        }
        else {
            /* Client Search - Tomi call here */
            /* Update APIstock if successful */
        }
        
    }
    
    @IBAction func addSymbol() {
        /*
         *  Adds to the current portofolio (session-time) and then sends it to Firebase Database
         */
        
        if self.portofolio[0][0] == "Add Stocks to see them here !" { // if new user, delete the default value from the portofolio
            self.portofolio = [[]]
        }
        
        /*
         self.APIstock = ["AAPL", "0.77"] // test stock transaction
         self.portofolio.append(self.APIstock)
         */
        
        self.firebaseClient = FirebaseClient(user: self.User!)
        
        self.firebaseClient?.uploadTransactionToUser(transaction: self.portofolio) {
            (result) in
            if result == true {
                print("Uploaded stock to portofolio !")
            }
            else {
                print("Failed to upload stock to portofolio.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        self.symbolInputLabel.addTarget(self, action: #selector(AddStocksController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Calls this function to predict symbol input
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.predictor.getClosestStrings(current: textField.text!) { // We change the value of the predictedLabel with whatever result we get from the SymbolHelper method
            (predicted) in
            DispatchQueue.main.async {
                self.predictionLabel.text = predicted
            }
        }
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
