//
//  SettingsViewController.swift
//  Dream App
//
//  Created by Akshaj Kanumuri on 1/1/24.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUsername()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Logout(_ sender: Any) {
            do {
                try Auth.auth().signOut()
                //self.performSegue(withIdentifier: "goToHome", sender: self)
            }
            catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    
    func setUsername() {
        if let currentUser = Auth.auth().currentUser {
            let userId = currentUser.uid
            ref.child("users").child(userId).observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let self = self else { return }
                
                if let userData = snapshot.value as? [String: Any],
                   let username = userData["username"] as? String {
                    // Set the username to the label
                    self.usernameLabel.text = username
                } else {
                    // Handle the case where username is not found
                    self.usernameLabel.text = "Unknown"
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
