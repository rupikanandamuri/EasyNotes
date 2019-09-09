//
//  Dashboard2ViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-20.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit
import RealmSwift

class addNotesViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet var textView : UITextView!
    @IBOutlet var headerView : UIView!
    @IBOutlet weak var headerViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet var underlineView : UIView!
    @IBOutlet weak var underlineViewLeadingConstraint : NSLayoutConstraint!
    
     var myNote = Notes()
    var tagTypeInSelectedNotes : String?
    var deletedButtonClicked = false
    var isNewNote = false
    var isAddNoteFromTable = false
    let defaults    = UserDefaults.standard
    //to get the current date so that we can delete temporary list within 7 days
    let date = Date()
    let formatter = DateFormatter()
    //to get make personal as default when it enter into add quick notes
    var isdefault = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = myNote.notes
       
        // Do any additional setup after loading the view.
         let realm = try! Realm()
        print(realm.configuration.fileURL)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        //to show by default personal tag.
        if isdefault{
            tagTypeInSelectedNotes = "personal"
        }
        if isNewNote == false{
            headerViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
            let deleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteNotes))
            self.navigationItem.rightBarButtonItem  = deleteBarButtonItem
        }
        else if isNewNote == true &&  isAddNoteFromTable == true {
            headerViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
            let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotes))
            self.navigationItem.rightBarButtonItem  = clearBarButtonItem
        }
        else
        {
            let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotes))
            self.navigationItem.rightBarButtonItem  = clearBarButtonItem
        }
    }
    @objc func clearNotes(){
        textView.text = ""
    }
    @objc func deleteNotes(){
        let realm = try! Realm()
       
        try! realm.write {
            realm.delete(myNote)
        }
         navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        if deletedButtonClicked == false{
          
            if isNewNote{
               addNote()
            }else{
                updateNote()
            }
           
        }
        
    }
    
    func addNote(){
        if let saveText = textView.text, saveText != " ", saveText.count > 0{
            //sending notes to relam notes class
            myNote.notes = saveText
            //sending date to relame date
            myNote.dateCreated = getCurrentDate()
            //sending tag value to relam tag
            if let slectedTagForNote = tagTypeInSelectedNotes{
                myNote.tag = slectedTagForNote
                myNote.expireDate = getExpiryDate() ?? ""
                //save in realm
                let realm = try! Realm()
                
                try! realm.write {
                    realm.add(myNote,update: false)
                }
            }
     }
}
    
    func getExpiryDate() -> String?{
        
        let currentDate = Date() // This will get the current Date in raw Date type format
        //Need to add 7 days to this date
        if let expiryRawDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate){
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            let formattedStringDate = formatter.string(from: expiryRawDate)
            return formattedStringDate
        }
        return .none
    }
    
    func updateNote(){
        if let saveText = textView.text{
            let realm = try! Realm()
            
            try! realm.write {
                myNote.notes = saveText
                myNote.dateCreated = getCurrentDate()
                realm.add(myNote, update: true)
            }
        }
    }
  
    func getCurrentDate() -> String{
        let rawDate = Date() //This will give the current date
        
        //NEdd to convert this into string format
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        
         let convertedString = formatter.string(from: rawDate)
        return convertedString
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    //to check whether user defaults contain value or not
    func contains(key: String) -> Bool {
        return UserDefaults.standard.value(forKey: "password") != nil
    }
    //MARK -for button tags
    @IBAction func personalButtonClciked(sender : UIButton){
        underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
           //to get tag type when button is pressed.
         tagTypeInSelectedNotes = "personal"

//        if contains(key: "password"){
//
//        }else{
//            showAlertAction()
//        }
    }
    
//    func showAlertAction(){
//        // Create the alert controller
//        let alertController = UIAlertController(title: "Password Protection", message: "personal notes are password protected", preferredStyle: .alert)
//
//        // Create the actions
//        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//            UIAlertAction in
//            NSLog("OK Pressed")
//            self.performSegue(withIdentifier: "goToPassword", sender: nil)
//        }
//        let skipAction = UIAlertAction(title: "Skip", style: UIAlertAction.Style.cancel) {
//            UIAlertAction in
//            NSLog("Skip Pressed")
//        }
//
//        // Add the actions
//        alertController.addAction(okAction)
//        alertController.addAction(skipAction)
//
//        // Present the controller
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    // work button clicked
    @IBAction func workButtonClciked(sender : UIButton){
       underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
        self.underlineView.backgroundColor = UIColor(red: 1.0, green: 156.0 / 255.0, blue: 62.0 / 255.0, alpha: 0.5)
        //to get tag type when button is pressed.
         tagTypeInSelectedNotes = "work"
    }
    //temporary button clicked
    @IBAction func temporaryBUttonClciked(sender : UIButton){
         underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
         self.underlineView.backgroundColor = UIColor(red: 91.0 / 255.0, green: 151.0 / 255.0, blue: 233.0 / 255.0, alpha: 0.5)
        //to get tag type when button is pressed.
        tagTypeInSelectedNotes = "temporary"
    }
    //imporatant button clicked
    @IBAction func importantButtonClciked(sender : UIButton){
         underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
        self.underlineView.backgroundColor = UIColor(red: 253.0 / 255.0, green: 69.0 / 255.0, blue: 69.0 / 255.0, alpha: 0.5)
          tagTypeInSelectedNotes = "important"
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
