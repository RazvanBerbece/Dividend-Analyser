//
//  RootInfoController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 25/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit

/*
 *  INITIAL CONTROLLER WITH SUGGESTIVE MESSAGE
 *  USERS CAN OPT TO SIGN UP OR TO SIGN IN
 */
class RootInfoController: UIViewController {
    
    /* IBOutlets */
    @IBOutlet weak var deletedAccountLabel: UILabel!
    
    /* View Variables */
    var userNeedsToSignUp : Bool?
    
    /* IBActions and button functions */
    @IBAction func userSignsUp() {
        
        self.userNeedsToSignUp = true
        
        self.performSegue(withIdentifier: "toCredentialScreen", sender: self)
        
    }
    
    @IBAction func userLogins() {
        
        self.userNeedsToSignUp = false
        
        self.performSegue(withIdentifier: "toCredentialScreen", sender: self)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCredentialScreen" {
            let credentialScreen = segue.destination as! ViewController
            credentialScreen.needsToSignUp = self.userNeedsToSignUp
        }
    }
    
}
