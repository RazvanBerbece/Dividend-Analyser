//
//  TransactionClient.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 12/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import Foundation
import Firebase

/* Manages operations on the UID Firebase Storage (ie: the user portofolio) */
public class FirebaseClient {
    
    private let User: User?
    
    init(user: User) {
        self.User = user
    }
    
    public func uploadTransactionToUser(transaction: [String], completion: @escaping (Bool) -> (Void)) {
        
        let dbRef = Database.database().reference() // holds the reference to the Realtime Database
        
        let usersRef = dbRef.child("users") // holds the reference to the Users container
        
        let specificUserRef = usersRef.child("\(String(describing: self.User!.uid))") // holds the reference to the current user container
        
        specificUserRef.setValue(transaction) // setting the users portofolio to the current built one
        
        print("Set values in Database.")
        
        completion(true)
        
    }
    
}
