//
//  UserPortofolioController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 13/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit

class UserPortofolioController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /* IBOutlets and view variables */
    @IBOutlet weak var portofolioTableView: UITableView!
    var model = [Portofolio]() // used to populate TableView
    var portofolioDataFromFirebase : [[String]]?
    
    /* Dividend Value Result */
    var dividendValue : Double?
    
    override func viewDidLoad() {
        
        /* Setting Delegates & Table View constants */
        self.portofolioTableView.delegate = self
        self.portofolioTableView.dataSource = self
        self.portofolioTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        super.viewDidLoad()
        
        /* Loop through received stocks and add them to the model if there is any stock found */
        if portofolioDataFromFirebase!.count == 0 {
            print("No symbols found in user's portofolio.")
        }
        else {
            self.dividendValue = 0.00
            for stock in portofolioDataFromFirebase! {
                let portofolioForStock = Portofolio(stockData: stock)
                if let stockDivValue = Double(portofolioForStock.stockDividend!) {
                    self.dividendValue! += stockDivValue
                }
                model.append(portofolioForStock)
            }
        }
        
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        /* This can be empty, presence required */
    }
    
    /* ----------- TableView Population Methodology ----------- */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = model[indexPath.row].stockName
        cell.detailTextLabel?.text = model[indexPath.row].stockDividend
        
        return cell;
    }
    
}
