//
//  CreateNewDreamViewController.swift
//  Dream App
//
//  Created by Akshaj Kanumuri on 12/30/23.
//

import UIKit
import Firebase

class CreateNewDreamViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var TitleTF: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var EnterDescriptionLabel: UILabel!
    
    let ref = Database.database().reference()
    
    //var ref = DatabaseReference!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            textView.layer.borderWidth = 1.0
            textView.layer.borderColor = UIColor.black.cgColor
        
            let attributedString = NSAttributedString(string: "Enter Description...", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        
            EnterDescriptionLabel.attributedText = attributedString
        
            navigationItem.hidesBackButton = true
        }
    
    @IBAction func SaveDream(_ sender: Any) {
        let title = TitleTF.text
        let description = textView.text
        
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            let date = Firebase.Date()
            let formattedDate = formatDate(date: date)
            guard let dreamKey = self.ref.child("users").child(uid).child("Dreams").childByAutoId().key else { return }
            
            let dreamData = [
                "title" : title,
                "date" : formattedDate,
                "description" : description
            ]
            
            self.ref.child("users").child(uid).child("Dreams").child(dreamKey).setValue(dreamData)
            self.performSegue(withIdentifier: "goToNext", sender: self)
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    @IBOutlet var SaveDream: UIView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
