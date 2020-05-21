//
//  UserScreenController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 11/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import UIGradient
import Kingfisher

class UserScreenController: UIViewController {
    
    /* IBOutlets and view variables */
    @IBOutlet weak var userGreet: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var updatePicButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    /* User Data Variables */
    var User : User?
    var authResult : AuthDataResult?
    var handle : AuthStateDidChangeListenerHandle?
    var transactions : [[String]] = []
    
    /* User Data Manager */
    var FirebaseClient : FirebaseClient?
    
    /* IBActions and button functions */
    @IBAction func signOut() {
        /* TODO ? */
        print("Trying to sign out ...")
    }
    
    @IBAction func settings() {
        /* Moving to SettingsScreen */
        self.performSegue(withIdentifier: "moveToSettings", sender: self)
    }
    
    override func viewDidLoad() {
        
        /* Making the profile picture view look like a circle & Other edits */
        self.profilePictureView.makeRoundCorners(byRadius: 100)
        self.profilePictureView.contentMode = .scaleAspectFit
        
        /* Load profile picture or use placeholder */
        self.FirebaseClient?.downloadUserProfilePic() {
            (image) in
            if image != nil {
                self.profilePictureView.image = image
            }
            else {
                self.profilePictureView.image = UIImage(named: "defaultUser")
            }
        }
        
        self.view.backgroundColor = UIColor.fromGradientWithDirection(.topToBottom, frame: self.view.frame, colors: [UIColor.gray, UIColor.lightGray, UIColor.white])
        
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserScreenController.openGalleryClick(tapGesture:)))
        
        self.updatePicButton.addGestureRecognizer(tapGestureRecognizer)
        
        self.loadData()
        
    }
    
    @IBAction func unwind(unwindSegue: UIStoryboardSegue) {
        if let stocksSourceController = unwindSegue.source as? AddStocksController {
            self.transactions = stocksSourceController.portofolio
            
            /* Calculating the user current dividend income after (probably) updating their portofolio */
            if self.transactions.count != 0 {
                var dividendValue : Double = 0.00
                for stock in self.transactions {
                    let portofolioForStock = Portofolio(stockData: stock)
                    if let stockDivValue = Double(portofolioForStock.getDividend()) {
                        
                        switch portofolioForStock.getRate() {
                        case "quarterly":
                            dividendValue += 4 * stockDivValue
                            break
                        case "monthly":
                            dividendValue += 12 * stockDivValue
                            break
                        default:
                            print("Stock has a wrong payrate parameter.")
                            break
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.amountLabel.text = "$\(String(format: "%.2f", dividendValue))"
                }
            }
        }
        else if let portofolioSourceController = unwindSegue.source as? UserPortofolioController {
            self.transactions = portofolioSourceController.portofolioDataFromFirebase!
            self.loadData() // load data as there could be an update made in the Portofolio screen
        }
        else if let settingsSourceController = unwindSegue.source as? SettingsScreenController {
            self.loadData() // load data as there could be an update made in the Settings screen
        }
    }
    
    /* Segue Performing Methodology */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /* Should add segue-specific for Portofolio transactions */
        if(segue.identifier == "moveToUserScreen") {
            let settingsVC = segue.destination as! SettingsScreenController
            if let currentUser = Auth.auth().currentUser { // The user is logged in on the current session
                settingsVC.User = currentUser
                settingsVC.authData = self.authResult!
                settingsVC.handle = self.handle!
            }
        }
        else if segue.identifier == "moveToPortofolio" {
            let portofolioVC = segue.destination as! UserPortofolioController
            if Auth.auth().currentUser != nil {
                portofolioVC.portofolioDataFromFirebase = self.transactions
            }
        }
        else if segue.identifier == "moveToAddStocks" {
            let addStocksVC = segue.destination as! AddStocksController
            if Auth.auth().currentUser != nil {
                addStocksVC.portofolio = self.transactions
                addStocksVC.User = self.User!
            }
        }
    }
    
    /* Loads all the user required data from Firebase */
    func loadData() {
        
        if let userDisplay = User!.displayName { // User set up a username already
            self.userGreet.text = "Hello, \(String(describing: userDisplay))"
        }
        else { // else use their email for the user screen
            self.userGreet.text = "\(String(describing: User!.email!))"
        }
        
        /* Download user portofolio data from Firebase Database */
        print(self.FirebaseClient!.downloadUserTransactions(completion: {
            (result) in
            if result.count > 0 {
                self.transactions = result
                
                /* Calculating the user current dividend income after the initial download */
                if self.transactions.count != 0 {
                    var dividendValue : Double = 0.00
                    for stock in self.transactions {
                        let portofolioForStock = Portofolio(stockData: stock)
                        if let stockDivValue = Double(portofolioForStock.getDividend()) {
                            
                            switch portofolioForStock.getRate() {
                            case "quarterly":
                                dividendValue += 4 * stockDivValue
                                break
                            case "monthly":
                                dividendValue += 12 * stockDivValue
                                break
                            default:
                                print("Stock has a wrong payrate parameter.")
                                break
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.amountLabel.text = "$\(String(format: "%.2f", dividendValue))"
                    }
                }
            }
            else {
                print("Nothing received from the download.")
            }
        }))
        
    }
    
    @objc func openGalleryClick(tapGesture: UITapGestureRecognizer) {
        self.setupImagePicker()
    }
    
}

/* Holds delegate for UIImagePickerController */
extension UserScreenController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.profilePictureView.image = image
            dismiss(animated: true, completion: nil)
            
            self.FirebaseClient?.uploadUserPhotoToStorage(image: image) {
                (url) in
                if url != nil {
                    print("Image uploaded to \(String(describing: url))")
                }
                else {
                    print("Image was not uploaded.")
                }
            }
        }
        
        
    }
    
    
}
