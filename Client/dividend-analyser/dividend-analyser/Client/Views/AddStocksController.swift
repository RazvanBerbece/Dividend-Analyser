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
    
    /* IBActions and button functions */
    @IBAction func searchSymbol() {
        
        let symbolInput = self.symbolInputLabel.text
        
        if symbolInput?.count == 0 {
            print("No input. Try searching for a stock symbol.")
        }
        else {
            /* Client - Tomi call here */
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
