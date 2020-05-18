//
//  UserPortofolioController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 13/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import Firebase

class UserPortofolioController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /* IBOutlets and view variables */
    @IBOutlet weak var portofolioTableView: UITableView!
    @IBOutlet weak var deleteResultLabel: UILabel!
    var model = [Portofolio]() // used to populate TableView
    var portofolioDataFromFirebase : [[String]]?
    
    /* Managers */
    let firebaseClient = FirebaseClient(user: Auth.auth().currentUser!)
    
    /* IBActions and button functions */
    @IBAction func deleteStockFromPortofolio(stock: Portofolio) {
        
        /* Finding the stock by name in the model */
        for (index, portofolio) in model.enumerated() {
            if portofolio.getName() == stock.getName() {
                /* Remove stock from both model and the [[String]] portofolio */
                portofolioDataFromFirebase?.remove(at: index)
                model.remove(at: index)
                print("Sucessfully deleted record from local portofolio.")
                break
            }
        }
        
        /* Uploading the updated portofolio to Firebase Database */
        self.firebaseClient.uploadTransactionToUser(transaction: portofolioDataFromFirebase!) {
            (result) in
            if result == true {
                print("Sucessfully deleted record from database.")
                
                self.deleteResultLabel.text = "Successfully deleted stock from portofolio."
                self.deleteResultLabel.textColor = UIColor(ciColor: .green)
            }
            else {
                print("An error occured while deleting stock from database")
                
                self.deleteResultLabel.text = "An error occured while deleting stock from database."
                self.deleteResultLabel.textColor = UIColor(ciColor: .red)
            }
        }
        
        /* Reload data with the updated portofolio */
        self.portofolioTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.fromGradientWithDirection(.topToBottom, frame: self.view.frame, colors: [UIColor.gray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.lightGray, UIColor.white, UIColor.white])
        
        /* Setting Delegates & Table View constants */
        self.portofolioTableView.delegate = self
        self.portofolioTableView.dataSource = self
        self.portofolioTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        super.viewDidLoad()
        
        /* Loop through received stocks and add them to the model if there is any stock found */
        if portofolioDataFromFirebase!.count == 0 {
            print("No symbols found in user's portofolio (downloaded from Firebase).")
        }
        else {
            for stock in portofolioDataFromFirebase! {
                let portofolioForStock = Portofolio(stockData: stock)
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
    
    /* This will get called to delete a specific stock from the user's portofolio */
    @objc func tableViewDelete(sender: UIButton) {
        self.deleteStockFromPortofolio(stock: model[sender.tag])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
        /* Creating the UIButton for the accessory type of the cell */
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark")!.withTintColor(UIColor(ciColor: .blue)), for: .normal)
        button.addTarget(self, action: #selector(tableViewDelete), for: .touchUpInside)
        button.sizeToFit()
        button.tag = indexPath.row // this keeps track of the row index -> can access model[tag]
        
        cell.textLabel?.text = model[indexPath.row].getName()
        cell.detailTextLabel?.text = model[indexPath.row].getDividend()
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        
        cell.textLabel?.textColor = UIColor(ciColor: .black)
        cell.detailTextLabel?.textColor = UIColor(ciColor: .black)
        
        cell.accessoryView = button
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
        return cell;
    }
    
}
