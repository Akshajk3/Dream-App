//
//  DreamJournalViewController.swift
//  Dream App
//
//  Created by Akshaj Kanumuri on 12/30/23.
//

import UIKit
import Firebase

class DreamJournalViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dreamView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let ref = Database.database().reference()
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDreams()
        
        //timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(deleteButtonPressed), userInfo: nil, repeats: true)
        
        for dream in scrollView.subviews {
            if let title = dream.viewWithTag(1) as? UILabel{
                print(title.text as Any)
            }
            if let button = dream.viewWithTag(5) as? UIButton {
                button.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
            }
        }
        // Do any additional setup after loading the view.
    }

    func loadDreams() {
        let currentUser = Auth.auth().currentUser
        let uid = currentUser!.uid
        let dreamsRef = ref.child("users").child(uid).child("Dreams")
        
        dreamsRef.observe(.value) { snapshot in
            guard snapshot.exists() else {
                self.titleLabel.text = "No Dreams Found"
                return
            }
            
            var totalContentHeight: CGFloat = 0
            
            for dreamSnapshot in snapshot.children {
                if let dreamData = dreamSnapshot as? DataSnapshot,
                   let dreamDetails = dreamData.value as? [String: Any] {
                    if let title = dreamDetails["title"] as? String,
                        let date = dreamDetails["date"] as? String,
                        let description = dreamDetails["description"] as? String {
                        self.titleLabel.text = title
                        self.dateLabel.text = date
                        self.descriptionLabel.text = description
                        
                        let newDream = self.duplicateDreamView(self.dreamView)
                        self.setDreamContent(for: newDream, p_title: title, p_date: date, p_description: description)
                        self.scrollView.addSubview(newDream)
                        
                        totalContentHeight += newDream.frame.size.height
                    }
                }
            }
            self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.width, height: totalContentHeight)
            self.scrollView.isScrollEnabled = true
            
        }
    }
    
    func duplicateDreamView(_ original: UIView) -> UIView {
        let duplicate = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: original)) as! UIView
        
        let yOffset = (CGFloat(scrollView.subviews.count) - 2) * duplicate.frame.size.height
        
        duplicate.frame.origin.y = original.frame.origin.y + yOffset
        
        print(CGFloat(scrollView.subviews.count))
        
        return duplicate
    }
    
    func setDreamContent(for view: UIView, p_title: String, p_date: String, p_description: String) {
        if let title = view.viewWithTag(1) as? UILabel,
           let date = view.viewWithTag(2) as? UILabel,
           let description = view.viewWithTag(3) as? UILabel {
            title.text = p_title
            date.text = p_date
            description.text = p_description
            print("content set")
        }
    }
    
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        print("Hello")
        if let dream = sender.superview {
            DeleteDream(dream: dream)
        }
    }
    
    func DeleteDream(dream: UIView) {
        print("hello world")
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            
            let dreamRef = ref.child("users").child(uid).child("Dreams")
            
            dreamRef.observe(.value) { snapshot in
                guard snapshot.exists() else {
                    print("No Dreams to Delete")
                    return
                }
                
                for dreamSnapshot in snapshot.children {
                    if let dreamData = dreamSnapshot as? DataSnapshot,
                       let dreamDetials = dreamData.value as? [String: Any] {
                        if let title = dreamDetials["title"] as? String {
                            let dreamName = dream.viewWithTag(1) as? UILabel
                            if dreamName!.text == title {
                                
                            }
                        }
                    }
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
