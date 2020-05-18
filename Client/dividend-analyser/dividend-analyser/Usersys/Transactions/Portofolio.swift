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
    private let stockName : String?
    private let stockDividend : String?
    private let stockCurrency : String?
    private let stockPayRate : String?
    
    init(stockData: [String]) {
        // One element in the [[String]] represents a single stock's information table
        let stockDataLength = stockData.count
        
        switch stockDataLength {
        case 1:
            self.stockName = stockData[0]
            self.stockDividend = ""
            self.stockCurrency = ""
            self.stockPayRate = ""
        case 2:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            self.stockCurrency = ""
            self.stockPayRate = ""
        case 3:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            self.stockCurrency = stockData[2]
            self.stockPayRate = ""
        case 4:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            self.stockCurrency = stockData[2]
            self.stockPayRate = stockData[3]
        default:
            self.stockName = ""
            self.stockDividend = ""
            self.stockCurrency = ""
            self.stockPayRate = ""
            print("No data for portofolio init !")
        }
        
    }
    
    /* Getter methods for fields */
    public func getName() -> String {
        return self.stockName!
    }
    
    public func getDividend() -> String {
        return self.stockDividend!
    }
    
    public func getCurrency() -> String {
        return self.stockCurrency!
    }
    
    public func getRate() -> String {
        return self.stockPayRate!
    }
    
}
