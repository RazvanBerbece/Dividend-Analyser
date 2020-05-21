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
    private let stockNumber : Double?
    private let stockLogo : String?
    
    init(stockData: [String]) {
        // One element in the [[String]] represents a single stock's information table
        let stockDataLength = stockData.count
        
        switch stockDataLength {
        case 1:
            self.stockName = stockData[0]
            self.stockDividend = ""
            self.stockCurrency = ""
            self.stockPayRate = ""
            self.stockNumber = 0
            self.stockLogo = ""
        case 2:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            self.stockCurrency = ""
            self.stockPayRate = ""
            self.stockNumber = 0
            self.stockLogo = ""
        case 3:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            self.stockCurrency = stockData[2]
            self.stockPayRate = ""
            self.stockNumber = 0
            self.stockLogo = ""
        case 4:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            self.stockCurrency = stockData[2]
            self.stockPayRate = stockData[3]
            self.stockNumber = 0
            self.stockLogo = ""
        case 5:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            self.stockCurrency = stockData[2]
            self.stockPayRate = stockData[3]
            self.stockNumber = Double(stockData[4])
            self.stockLogo = ""
        case 6:
            self.stockName = stockData[0]
            self.stockDividend = stockData[1]
            self.stockCurrency = stockData[2]
            self.stockPayRate = stockData[3]
            self.stockNumber = Double(stockData[4])
            self.stockLogo = stockData[5]
        default:
            self.stockName = ""
            self.stockDividend = ""
            self.stockCurrency = ""
            self.stockPayRate = ""
            self.stockNumber = 0
            self.stockLogo = ""
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
    
    public func getLogoURL() -> String {
        return self.stockLogo!
    }
    
    public func getNumber() -> Double {
        return self.stockNumber!
    }
    
}
