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
    @IBOutlet var temporaryButton : UIButton!
    
    //to connect tool bar is a view  which is in the top of view controller
    @IBOutlet var toolBar : UIView!
    @IBOutlet var reminderButton : UIButton!
    var myNote = Notes()
    var tagTypeInSelectedNotes : NoteType?
    var deletedButtonClicked = false
    var isNewNote = false
    var notesFromDashboard = false
    var isAddNoteFromTable = false
    //to get make personal as default when it enter into add quick notes
    var isdefault = true
    
    @IBOutlet var bulletButton : UIButton!
    @IBOutlet var boldButton : UIButton!
    @IBOutlet var italicButton : UIButton!
    @IBOutlet var underlineButton : UIButton!
    var bulletMode = false
    var boldMode = false
    var italicMode = false
    var underlineMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = myNote.notes
        
        textView.inputAccessoryView = toolBar
        //to wrap last words
        textView.textContainer.lineBreakMode = .byCharWrapping
        //For scrolllling text view,I was able to achieve this by simply enabling alwaysBounceVertical, and making sure User interaction and scrolling was enabled.
        textView.alwaysBounceVertical = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        //to show by default personal tag.
        
        if isNewNote == false{
            headerViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }else if isNewNote == true &&  isAddNoteFromTable == true{
            //We get here when it is new note and add note cliked on table view
            headerViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        else if notesFromDashboard == true{
            //we got here from dashboard if there is no 
            headerViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        customiseNavBarButtons()
        
    }
    override func viewWillLayoutSubviews() {
        
        if isdefault{
            //tagTypeInSelectedNotes = .temporary
            temporaryBUttonClciked(sender:temporaryButton )
        }
    }
    
    func customiseNavBarButtons(){
        if tagTypeInSelectedNotes == .work{
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
            if isNewNote == true{
                let clearBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearNotes))
                self.navigationItem.rightBarButtonItem  = clearBarButtonItem
            }else{
                let deleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteNotes))
                self.navigationItem.rightBarButtonItem  = deleteBarButtonItem
            }
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
            myNote.updatedDate = NoteManager.shared.getCurrentDate()
            //sending tag value to relam tag
            if let slectedTagForNote = tagTypeInSelectedNotes{
                myNote.tag = slectedTagForNote.rawValue
                myNote.expireDate = NoteManager.shared.getExpiryDate() ?? ""
                NoteManager.shared.addNote(myNote)
            }
        }
    }
    
    
    
    func updateNote(){
        //You already deleted note, so it will be invalidated
        if myNote.isInvalidated == false{
            if let saveText = textView.text{
                NoteManager.shared.updateNote(myNote, saveText)
            }
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            
            adBulletButtonClicked(true)
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
        let personalColorForUnderline = NoteManager.shared.getColor(NoteType.personal.rawValue)
        self.underlineView.backgroundColor = personalColorForUnderline
        
        //to get tag type when button is pressed.
        tagTypeInSelectedNotes = .personal
        reminderButton.isHidden = true
        
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
         let workColorForUnderline = NoteManager.shared.getColor(NoteType.work.rawValue)
        self.underlineView.backgroundColor = workColorForUnderline
        //to get tag type when button is pressed.
        tagTypeInSelectedNotes = .work
        reminderButton.isHidden = true
    }
    //temporary button clicked
    @IBAction func temporaryBUttonClciked(sender : UIButton){
        underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
        let tempColorForUnderline = NoteManager.shared.getColor(NoteType.temporary.rawValue)
        self.underlineView.backgroundColor = tempColorForUnderline
        //to get tag type when button is pressed.
        tagTypeInSelectedNotes = .temporary
        reminderButton.isHidden = true
    }
    //imporatant button clicked
    @IBAction func importantButtonClciked(sender : UIButton){
        underlineViewLeadingConstraint.constant = sender.frame.origin.x + 20
        let impColorForUnderline = NoteManager.shared.getColor(NoteType.important.rawValue)
        self.underlineView.backgroundColor = impColorForUnderline
        tagTypeInSelectedNotes = .important
        reminderButton.isHidden = false
    }
    
    func getNewLineStrings() -> [String]{
        let noBullets = textView.text.replacingOccurrences(of: "\u{2022}", with: "")
        let arr = noBullets.components(separatedBy: "\n")
        var temp = [String]()
        for str in arr{
            if str == "" || str == " " || str == "  "{
                
            }else{
                temp.append(str)
            }
        }
        return temp
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //to add bullet
    @IBAction func adBulletButtonClicked( _ newLine : Bool){
        
        bulletMode = bulletButton.isSelected
        if bulletButton.isSelected{
            bulletButton.applyBorderAndRadius()
        }else{
            bulletButton.removeBorder()
        }
        bulletButton.isSelected = !bulletButton.isSelected
        var fullAttributedString = NSMutableAttributedString()
        let convertTextToString = getNewLineStrings()
        for  string in convertTextToString
        {
            addBullet(&fullAttributedString, string)
        }
         
        textView.attributedText = fullAttributedString
    }
    
    
    func addBullet(_ attrString : inout NSMutableAttributedString, _ str : String){
        let bulletPoint: String = "\u{2022}"
        let formattedString: String = "\(bulletPoint) \(str) \n"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
         
        let paragraphStyle = createParagraphAttribute()
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.font : textView.font!], range: NSMakeRange(0, attributedString.length))
        attrString.append(attributedString)
    }
    
    func createParagraphAttribute() ->NSParagraphStyle
       {
           var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: NSDictionary() as! [NSTextTab.OptionKey : Any])]
           paragraphStyle.defaultTabInterval = 15
           paragraphStyle.firstLineHeadIndent = 0
           paragraphStyle.headIndent = 15
    
           return paragraphStyle
       }
    //to add reminder
    @IBAction func reminderButtonClicked(){
        
      performSegue(withIdentifier: "Reminder", sender: nil)
        
    }
    //to add Bold
    @IBAction func boldButtonClicked(){
        boldButton.isSelected = !boldButton.isSelected
        boldMode = boldButton.isSelected
       if boldMode && italicMode{
           boldButton.applyBorderAndRadius()
          textView.font = NoteManager.shared.getBoldItalicFont()
       }else if boldMode{
           boldButton.applyBorderAndRadius()
          textView.font = NoteManager.shared.getBoldFont()
       }else if italicMode{
           boldButton.removeBorder()
           textView.font = NoteManager.shared.getItalicFont()
       }else{
            boldButton.removeBorder()
            textView.font = NoteManager.shared.getNormalFont()
        }
      
    }
    
    @IBAction func italicButtonClicked(){
        italicButton.isSelected = !italicButton.isSelected
        italicMode = italicButton.isSelected
        
         if boldMode && italicMode{
            italicButton.applyBorderAndRadius()
            textView.font = NoteManager.shared.getBoldItalicFont()
         }else if italicMode{
             italicButton.applyBorderAndRadius()
             textView.font = NoteManager.shared.getItalicFont()
         }else if boldMode{
             italicButton.removeBorder()
             textView.font = NoteManager.shared.getBoldFont()
         }else{
            italicButton.removeBorder()
            textView.font = NoteManager.shared.getNormalFont()
        }
    }
    
    @IBAction func increaseFontSize(){
        NoteManager.shared.fontSize += 3
        if boldMode{
            textView.font = NoteManager.shared.getBoldFont()
        }else{
            textView.font = NoteManager.shared.getNormalFont()
        }
        
    }
    
    @IBAction func decreaseFontSize(){
        NoteManager.shared.fontSize -= 3
        if boldMode{
            textView.font = NoteManager.shared.getBoldFont()
        }else{
            textView.font = NoteManager.shared.getNormalFont()
        }
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    
}
