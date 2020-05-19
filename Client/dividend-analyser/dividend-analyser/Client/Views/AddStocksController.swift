//
//  AddStocksController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 13/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import FirebaseAuth
import UIGradient
import Kingfisher

class AddStocksController: UIViewController, UITextFieldDelegate {
    
    /* IBOutlets and View Variables */
    @IBOutlet weak var symbolInputLabel: UITextField! // Also used as a warning if no data is found for given stock symbol
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
    @IBAction func searchSymbol() {
        
        let symbolInput = self.symbolInputLabel.text // this will be passed to the API
        
        if symbolInput?.count == 0 {
            print("No input. Try searching for a stock symbol.")
        }
        else {
            /* Client Search - Tomi call here */
            newClient.getDataFrom(symbolInput!) {
                (data) in
                if data.count != 0 {
                    self.symbolLabel.text = data[0].uppercased()
                    self.valueLabel.text = "$\(data[1]) / \(data[3] == "quarterly" ? "quarter" : "month")"
                    self.methodLabel.text = data[3]
                    
                    self.APIstock = data
                    
                    self.addStockResultLabel.text = "Press the button below to add to your portofolio."
                    self.addStockResultLabel.textColor = UIColor(ciColor: .green)
                    
                    self.logoView.kf.setImage(with: URL(string: data[4]))
                }
                else {
                    print("No stock found using the given symbol.")
                    
                    self.addStockResultLabel.text = "No stock found using the given symbol. Try again."
                    self.addStockResultLabel.textColor = UIColor(ciColor: .red)
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
                self.portofolio = [[]]
            }
            else {
                self.portofolio.append([])
            }
        }
        
        // self.APIstock = ["AAPL", "0.77", ...] // test stock transaction
        self.portofolio[self.portofolio.count - 1].append(contentsOf: self.APIstock)
        
        
        self.firebaseClient = FirebaseClient(user: self.User!)
        
        self.firebaseClient?.uploadTransactionToUser(transaction: self.portofolio) {
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
        
        /* Creating a gradient background using UIGradient */
        self.view.backgroundColor = UIColor.fromGradientWithDirection(.topToBottom, frame: self.view.frame, colors: [UIColor.gray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.white, UIColor.white])
        
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
