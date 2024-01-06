//
//  ViewController.swift
//  Dream App
//
//  Created by Akshaj Kanumuri on 12/12/23.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser {
            print("User alredy logged in")
            self.performSegue(withIdentifier: "goToNext", sender: self)
        }
        else {
            print("No one logged in")
        }
        
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }


}

