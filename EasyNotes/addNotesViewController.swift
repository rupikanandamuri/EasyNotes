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
    //to get make personal as default when it enter into add quick notes
    var isdefault = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = myNote.notes
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
        }else if isNewNote == true &&  isAddNoteFromTable == true {
            //We get here when it is new note and add note cliked on table view
            headerViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        customiseNavBarButtons()
        
    }
    
    func customiseNavBarButtons(){
        if tagTypeInSelectedNotes == "work"{
            if isNewNote == false{
                let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotes))
                let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
                let deleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteNotes))
                self.navigationItem.rightBarButtonItems  = [clearBarButtonItem,deleteBarButtonItem,shareButton]
            }else{
                let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotes))
                let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
                self.navigationItem.rightBarButtonItems  = [clearBarButtonItem,shareButton]
            }
           
        }else{
            let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotes))
            self.navigationItem.rightBarButtonItem  = clearBarButtonItem
        }
    }
   
    @objc func shareButtonPressed(){
        if let string = textView.text{
            let activityViewController =
                UIActivityViewController(activityItems: [string],
                                         applicationActivities: nil)
            
            present(activityViewController, animated: true) {
                // ...
            }
        }
    }
    
    @objc func clearNotes(){
        textView.text = ""
    }
    
    @objc func deleteNotes(){
        NoteManager.shared.deleteNote(myNote)
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
            myNote.dateCreated = NoteManager.shared.getCurrentDate()
            //sending tag value to relam tag
            if let slectedTagForNote = tagTypeInSelectedNotes{
                myNote.tag = slectedTagForNote
                myNote.expireDate = NoteManager.shared.getExpiryDate() ?? ""
                NoteManager.shared.addNote(myNote)
            }
        }
    }
    
    
    
    func updateNote(){
        if let saveText = textView.text{
            NoteManager.shared.updateNote(myNote, saveText)
        }
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
        return UserDefaults.standard.value(forKey: key) != nil
    }
    
    //MARK -for button tags
    @IBAction func personalButtonClciked(sender : UIButton){
        underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
        self.underlineView.backgroundColor = UIColor.EasyNoteTheme.personalColor
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
        self.underlineView.backgroundColor = UIColor.EasyNoteTheme.workColor
        //to get tag type when button is pressed.
        tagTypeInSelectedNotes = "work"
    }
    //temporary button clicked
    @IBAction func temporaryBUttonClciked(sender : UIButton){
        underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
        self.underlineView.backgroundColor = UIColor.EasyNoteTheme.temporaryColor
        //to get tag type when button is pressed.
        tagTypeInSelectedNotes = "temporary"
    }
    //imporatant button clicked
    @IBAction func importantButtonClciked(sender : UIButton){
        underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
        self.underlineView.backgroundColor = UIColor.EasyNoteTheme.impColor
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
