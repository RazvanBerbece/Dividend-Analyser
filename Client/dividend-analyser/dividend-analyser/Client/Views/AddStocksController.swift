//
//  AddStocksController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 13/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit

class AddStocksController: UIViewController {
    
    /* IBOutlets and View Variables */
    @IBOutlet weak var symbolInputLabel: UITextField! // Also used as a warning if no data is found for given stock symbol
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    /* User Variables */
    var portofolio : [[String]] = [] // this will be updated and sent
    
    /* IBActions and button functions */
    @IBAction func searchSymbol() {
        
        let symbolInput = self.symbolInputLabel.text // this will be passed to the API
        
        if symbolInput?.count == 0 {
            print("No input. Try searching for a stock symbol.")
        }
        else {
            /* Client Search - Tomi call here */
        }
        
    }
    
    @IBAction func addSymbol() {
        // TODO
        /*
         *  Adds to the current portofolio (session-time) and then sends it to Firebase Database
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
