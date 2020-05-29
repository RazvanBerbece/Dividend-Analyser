//
//  TransactionClient.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 12/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

/* Manages operations on the UID Firebase Storage (ie: the user portofolio) */
public class FirebaseClient {
    
    private let User: User?
    
    init(user: User) {
        self.User = user
    }
    
    /* Uploads a certain transaction to the Firebase Databse of the current user */
    public func uploadTransactionToUser(transaction: [[String]], completion: @escaping (Bool) -> (Void)) {
        
        let dbRef = Database.database().reference() // holds the reference to the Realtime Database
        let usersRef = dbRef.child("users") // holds the reference to the Users container
        let specificUserRef = usersRef.child("\(String(describing: self.User!.uid))") // holds the reference to the current user container
        
        specificUserRef.setValue(transaction) // setting the users portofolio to the current built one
        
        print("Set values in Database.")
        completion(true)
        
    }
    
    /* This functions deletes all the data related to the user from Firebase (Auth, Database, Storage) */
    public func deleteUserData(completion: @escaping (Bool) -> (Void)) {
        
        /* Deleting Auth */
        self.User?.delete {
            (error) in
            if error == nil {
                /* Deleting Database Values */
                let dbRef = Database.database().reference() // holds the reference to the Realtime Database
                let usersRef = dbRef.child("users") // holds the reference to the Users container
                let specificUserRef = usersRef.child("\(String(describing: self.User!.uid))") // holds the reference to the current user container
                
                specificUserRef.removeValue() {
                    (error, _) in
                    if error == nil {
                        print("Deleted transactions from Firebase.")
                        /* Deleting Storage Values if transactions were successfully deleted */
                        let userProfilePicRef = Storage.storage().reference().child("profilePics").child("\(String(describing: self.User!.uid))").child("profilePic.jpg")
                        userProfilePicRef.delete {
                            error in
                            if error == nil {
                                print("Deleted stored data from Firebase.")
                                completion(true)
                            }
                            else {
                                print("error = \(String(describing: error))")
                                completion(false)
                            }
                        }
                    }
                    else {
                        print("error = \(String(describing: error))")
                        completion(false)
                    }
                }
            }
            else {
                print("error = \(String(describing: error))")
                completion(false)
            }
        }
        
    }
    
    /* Downloads the list of transactions (ie: the portofolio) of a user */
    public func downloadUserTransactions(completion: @escaping ([[String]]) -> (Void)) {
        
        let dbRef = Database.database().reference()
        let usersRef = dbRef.child("users")
        let specificUserRef = usersRef.child("\(String(describing: self.User!.uid))")
        
        specificUserRef.observeSingleEvent(of: .value, with: { // Transactions download once when user first logins
            (snapshot) in
            
            if let transactions = snapshot.value as? [[String]] {
                print("Got data from download : \(transactions)")
                completion(transactions)
            }
            else {
                completion([[]])
            }
        }) { (error) in
            // Something occured while downloading the data
            print("error = \(error)")
            completion([[]])
        }
    }
    
    /* Uploads to Firebase Storage the user's choice of profile picture */
    public func uploadUserPhotoToStorage(image: UIImage, completion: @escaping (URL?) -> (Void)) {
        
        let userProfilePicRef = Storage.storage().reference().child("profilePics").child("\(String(describing: self.User!.uid))").child("profilePic.jpg")
        
        let imgData = image.jpegData(compressionQuality: 0.5)
        
        userProfilePicRef.putData(imgData!, metadata: nil) {
            (metadata, error) in
            if error == nil {
                userProfilePicRef.downloadURL(completion: {
                    (url, error) in
                    if error == nil {
                        print("Got URL : \(String(describing: url))")
                        completion(url)
                    }
                    else {
                        print("URL error = \(String(describing: error))")
                        completion(nil)
                    }
                })
            }
            else {
                print("DATA error = \(String(describing: error))")
                completion(nil)
            }
        }
        
    }
    
    /* Downloads the user's profile pic from Firebase Storage */
    public func downloadUserProfilePic(completion: @escaping (UIImage?) -> (Void)) {
        
        let userProfilePicRef = Storage.storage().reference().child("profilePics").child("\(String(describing: self.User!.uid))").child("profilePic.jpg")
        
        userProfilePicRef.getData(maxSize: 35 * 1024 * 1024) {
            (data, error) in
            if let error = error {
                print("DOWNLOAD error = \(error)")
                completion(nil)
            }
            else {
                completion(UIImage(data: data!)!)
            }
        }
        
    }
    
}
