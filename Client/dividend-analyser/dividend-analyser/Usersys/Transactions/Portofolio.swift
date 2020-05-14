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
        let stockDataLength = stockData.count
        
        switch stockDataLength {
        case 1:
            self.stockName = stockData[0]
            self.stockDividend = ""
        case 2:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            /*
             case 3:
             self.stockName = stockData[0]
             self.stockDividend = stockData[1]
             self.stockCurrency = stockData[2]
             case 4:
             self.stockName = stockData[0]
             self.stockDividend = stockData[1]
             self.stockCurrency = stockData[2]
             self.stockPayRate = stockData[3]
             */
        default:
            self.stockName = ""
            self.stockDividend = ""
            print("No data for portofolio init !")
        }
        
    }
    
}
