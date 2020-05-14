//
//  Portofolio.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 14/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation

/* Class object which can be used as a model to populate a TableView */
public class Portofolio : NSObject {
    
    // let stockIcon : String?
    let stockName : String?
    let stockDividend : String?
    // let stockCurrency : String?
    // let stockPayRate : String?
    
    init(stockData: [String]) {
        // One element in the [[String]] represents a single stock's information table
        self.stockName = stockData[0]
        self.stockDividend = stockData[1]
        
        /* TO BE ADDED WHEN DOWNLOADED DATA IS SANITISED AND READY FOR DISPLAY
         self.stockCurrency = stockData[2]
         self.stockPayRate = stockData[3]
         */
        
    }
    
}
