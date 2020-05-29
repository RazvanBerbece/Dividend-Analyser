//
//  UserPortofolioController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 13/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

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
        
        if portofolioDataFromFirebase?.count == 0 {
            portofolioDataFromFirebase = [["Add Stocks to see them here !"]]
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
        
        /* Drawing a Horizontal Line under modal header */
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 15, y: 125))
        path.addLine(to: CGPoint(x: 360, y: 125))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
        
        /* Setting Delegates & Table View constants */
        self.portofolioTableView.delegate = self
        self.portofolioTableView.dataSource = self
        self.portofolioTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.portofolioTableView.layer.backgroundColor = UIColor.clear.cgColor
        self.portofolioTableView.backgroundColor = .clear
        
        super.viewDidLoad()
        
        /* Loop through received stocks and add them to the model if there is any stock found
         * Can be iterated without any exception, as the portofolio always has one element in it (default value)
         */
        for stock in portofolioDataFromFirebase! {
            let portofolioForStock = Portofolio(stockData: stock)
            model.append(portofolioForStock)
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
        button.setImage(UIImage(systemName: "xmark")!, for: .normal)
        button.tintColor = UIColor.init(red: 63.0/255.0, green: 129.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(tableViewDelete), for: .touchUpInside)
        button.sizeToFit()
        button.tag = indexPath.row // this keeps track of the row index -> can access model[tag]
        
        /* Setting the cell with stock data */
        if self.model.count != 0 && self.model[indexPath.row].getDividend() != "" {
            
            cell.textLabel!.text = "\(model[indexPath.row].getName()) x \(model[indexPath.row].getNumber()) shares"
            cell.detailTextLabel!.text = "$\(String(format: "%.2f", Double(model[indexPath.row].getDividend())!)) / \(model[indexPath.row].getRate())"
            
            /* Cell Text Font & Size */
            cell.textLabel!.font = UIFont.systemFont(ofSize: 20)
            cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 15)
            
            /*  Setting the accessory view of the cell to the button
             *  which deletes records from the portofolio
             */
            cell.accessoryView = button
            
            /* Making the Stock Logos rounded */
            cell.imageView!.frame.size = CGSize(width: 60, height: 60)
            cell.imageView!.layer.cornerRadius = 20
            cell.imageView!.layer.masksToBounds = true
            
            /* Stock Logo Methodology using KingFisher */
            if model[indexPath.row].getLogoURL() != "" {
                
                let url = URL(string: "\(model[indexPath.row].getLogoURL())")
                // Downsampling
                let processor = DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))
                cell.imageView!.kf.indicatorType = .activity
                cell.imageView!.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "defaultStock"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                {
                    result in
                    switch result {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print("error = \(error)")
                    }
                }
            }
            else {
                cell.imageView!.image = UIImage(systemName: "defaultStock")
            }
        }
        
        /* Making the cells transparent */
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        
        return cell;
    }
    
}
