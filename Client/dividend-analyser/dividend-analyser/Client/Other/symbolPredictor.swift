//
//  symbolPredictor.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 17/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import SwiftCSV

public class SymbolHelper {
    
    private var csv : CSV?
    private let csvFile : String = "companylist"
    
    init() {
        if let csvFileURL = Bundle.main.url(forResource: self.csvFile, withExtension: "csv") {
            print(csvFileURL)
            do { // try to read the data at the file as CSV in Swift
                self.csv = try CSV(url: csvFileURL)
            }
            catch _ as CSVParseError {
                print("Parsing error occured.")
            } catch {
                print("Error occured while reading from URL.")
            }
        }
        else {
            print("File \(self.csvFile + ".csv") not found")
        }
    }
    
    /* Compares the current given input with the whole list of symbols, suggesting various symbols to be added */
    public func getClosestStrings(current: String, completion: @escaping (String) -> (Void)) {
        
        let csvNamedColumns = self.csv!.namedColumns // list which holds each column name with a list of all inputs for the given column
        
        let uppercasedCurrent = current.uppercased()
        
        for symbol in csvNamedColumns["Symbol"]! {
            if symbol.contains(uppercasedCurrent) {
                print(symbol)
                completion(symbol)
            }
        }
        
    }
    
}
