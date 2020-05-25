//
//  AddStocksController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 13/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class AddStocksController: UIViewController, UITextFieldDelegate {
    
    /* IBOutlets and View Variables */
    @IBOutlet weak var symbolInputLabel: UITextField!
    @IBOutlet weak var numberStocksInput: UITextField!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var addStockResultLabel: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    
    /* User Variables */
    var portofolio : [[String]] = [] // this will be updated and sent
    var User : User?
    
    /* Current stock from API */
    var APIstock : [String] = []
    
    /* Managers */
    var firebaseClient : FirebaseClient?
    let predictor = SymbolHelper()
    var newClient = Client()
    
    /* IBActions and button functions */
    func searchSymbol(completion: @escaping (Bool) -> (Void)) {
        
        let symbolInput = self.symbolInputLabel.text // passed to API
        let numberStocks = self.numberStocksInput.text
        
        var doubleNumberStocks : Double? // passed to API
        
        if numberStocks != "" {
            doubleNumberStocks = Double(numberStocks!)!
        }
        else {
            doubleNumberStocks = 1
        }
        
        if symbolInput?.count == 0 {
            print("No input. Try searching for a stock symbol.")
        }
        else {
            /* Client Search - Tomi call here */
            newClient.getDataFrom(symbolInput!, doubleNumberStocks!) {
                (data) in
                if data.count != 0 {
                    self.symbolLabel.text = data[0].uppercased()
                    self.valueLabel.text = "$\(data[1]) / \(data[3] == "quarterly" ? "quarter" : "month")"
                    self.methodLabel.text = data[3]
                    
                    self.APIstock = data
                    
                    self.addStockResultLabel.text = "Press the button below to add to your portofolio."
                    self.addStockResultLabel.textColor = UIColor(ciColor: .green)
                    
                    self.logoView.layer.cornerRadius = 42
                    self.logoView.kf.setImage(with: URL(string: data[5]))
                    
                    completion(true)
                }
                else {
                    print("No stock found using the given symbol.")
                    
                    self.addStockResultLabel.text = "No stock found using the given symbol. Try again."
                    self.addStockResultLabel.textColor = UIColor(ciColor: .red)
                    
                    completion(false)
                }
            }
        }
        
    }
    
    @IBAction func addSymbol() {
        
        /*
         *  Adds to the current portofolio (session-time) and then sends it to Firebase Database
         */
        
        if self.portofolio[0].count != 0 {
            if self.portofolio[0][0] == "Add Stocks to see them here !" { // if new user, delete the default value from the portofolio
                self.portofolio = []
            }
            
            var alreadyInPortofolio : Bool = false
            
            /* Check if the stock is already in the user's portofolio*/
            for (index, stock) in portofolio.enumerated() {
                if stock[0] == self.APIstock[0] {
                    portofolio[index][4] = "\(Double(Double(portofolio[index][4])! + Double(self.APIstock[4])!))"
                    portofolio[index][1] = "\(Double(Double(portofolio[index][1])! + Double(self.APIstock[1])!))"
                    alreadyInPortofolio = true
                }
            }
            
            if !alreadyInPortofolio {
                self.portofolio.append([])
                self.portofolio[self.portofolio.count - 1].append(contentsOf: self.APIstock)
            }
        }
        else { // empty portofolio for user
            self.portofolio.append([])
            self.portofolio[self.portofolio.count - 1].append(contentsOf: self.APIstock)
        }
        
        self.firebaseClient = FirebaseClient(user: self.User!)
        
        self.firebaseClient!.uploadTransactionToUser(transaction: self.portofolio) {
            (result) in
            if result == true {
                print("Uploaded stock to portofolio !")
                
                self.addStockResultLabel.text = "Successfully added stock to portofolio."
                self.addStockResultLabel.textColor = UIColor(ciColor: .green)
            }
            else {
                print("Failed to upload stock to portofolio.")
                
                self.addStockResultLabel.text = "An error occured while adding stock to portofolio."
                self.addStockResultLabel.textColor = UIColor(ciColor: .red)
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* Looks for single or multiple taps */
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        
        /* Setting TextField Delegates */
        self.symbolInputLabel.delegate = self
        self.numberStocksInput.delegate = self
        
        self.symbolInputLabel.addTarget(self, action: #selector(AddStocksController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /* Calls this function when the tap is recognized */
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /* Calls this function to predict symbol input */
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.predictor.getClosestStrings(current: textField.text!) { // We change the value of the predictedLabel with whatever result we get from the SymbolHelper method
            (predicted) in
            DispatchQueue.main.async {
                self.predictionLabel.text = predicted
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextField.DidEndEditingReason) {
        
        if reason == .committed {
            
            /* Requesting the symbol & Append to list if neccessary */
            self.searchSymbol() {
                (result) in
                if result == true {
                    print("Search finished successfully.")
                }
            }
            
        }
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        /* This can be empty, presence required for unwinding */
    }
    
}
