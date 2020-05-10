//
//  ViewController.swift
//  dividend-analyser
//
//  Created by Razvan-Antonio Berbece on 10/05/2020.
//  Copyright © 2020 Razvan-Antonio Berbece. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    /* Initialising the State Handler */
    var handle : AuthStateDidChangeListenerHandle? = nil

    override func viewDidLoad() {
        
        /* Adding the gradient overlay to the main view */
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.gray.cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
        
        /* Handler for Firebase functionality */
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // User data can be handled here
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      /* Removing the Firebase handler */
      Auth.auth().removeStateDidChangeListener(handle!)
    }

}

