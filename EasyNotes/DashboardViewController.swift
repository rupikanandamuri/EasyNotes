//
//  DashboardViewController.swift
//  EasyNotes
//
//  Created by Rupika on 2019-08-13.
//  Copyright © 2019 Rupika. All rights reserved.
//

import UIKit
import RealmSwift

class DashboardViewController: UIViewController {
    
    @IBOutlet var personalView : UIView!{
        didSet{
            personalView.applyRadius()
        }
    }
    @IBOutlet var workView : UIView!{
        didSet{
            workView.applyRadius()
        }
    }
    @IBOutlet var temporaryView : UIView!{
        didSet{
            temporaryView.applyRadius()
        }
    }
    @IBOutlet var importantView : UIView!{
        didSet{
            importantView.applyRadius()
        }
    }
    
    @IBOutlet var personalNotesCount : UILabel!
    @IBOutlet var workNotesCount : UILabel!
    @IBOutlet var temporaryNotesCount : UILabel!
    @IBOutlet var importantNotesCount : UILabel!
    @IBOutlet var personalLastModified : UILabel!
    @IBOutlet var workLastModified : UILabel!
    @IBOutlet var temporaryLastModified : UILabel!
    @IBOutlet var importantLastModified : UILabel!
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NoteManager.shared.deleteExpiredNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        //in dash board displaying how many notes are there in each category.
        countNotesInEachCategory()
        updateModifiedDateOnDashboard()
        updateCardsTheme()
    }
    
    func updateCardsTheme(){
        workView.backgroundColor = NoteManager.shared.getColor(NoteType.work.rawValue)
        temporaryView.backgroundColor = NoteManager.shared.getColor(NoteType.temporary.rawValue)
        importantView.backgroundColor = NoteManager.shared.getColor(NoteType.important.rawValue)
        personalView.backgroundColor = NoteManager.shared.getColor(NoteType.personal.rawValue)
    }
    
    
    @IBAction func addNotesButtonClicked(){
        performSegue(withIdentifier: "addNotes", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNotes" {
            if let vc = segue.destination as? addNotesViewController{
                if  sender == nil {
                    vc.isNewNote = true
                    
                }
            }
        }
    }
    
    //to display no of notes in every catergory count label
    func countNotesInEachCategory(){
        personalNotesCount.text = String(NoteManager.shared.getPersonalNoteCount())
        workNotesCount.text = String(NoteManager.shared.getWorkNoteCount())
        temporaryNotesCount.text = String(NoteManager.shared.getTempNoteCount())
        importantNotesCount.text = String(NoteManager.shared.getImpNoteCount())
    }
    
    //to update modified date on bashboard
    func updateModifiedDateOnDashboard(){
        personalLastModified.text = NoteManager.shared.getLastModifiedNote(.personal)
        workLastModified.text = NoteManager.shared.getLastModifiedNote(.work)
        importantLastModified.text = NoteManager.shared.getLastModifiedNote(.important)
        temporaryLastModified.text = NoteManager.shared.getLastModifiedNote(.temporary)
    }
    
    
    @IBAction func addPersonalButtonClicked(){
        if  NoteManager.shared.getPersonalNoteCount() > 0{
            let nextViewController = NoteManager.shared.getPersonalPasscodeVc()
            nextViewController.tagColor = personalView.backgroundColor
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
             // performSegue(withIdentifier: "addNotes", sender: nil)
            //when there are no notes available in table list when u click on any tag in dahsboard it will take you to add notes by defaitl tag u clicked to write notes.
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "WriteNewNotes") as! addNotesViewController
            nextViewController.isNewNote = true
            nextViewController.notesFromDashboard = true
            nextViewController.tagTypeInSelectedNotes = NoteType(rawValue: "personal")
            nextViewController.isdefault = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
               
        }
        
    }
    
    @IBAction func addWorkButtonClicked(){
        if NoteManager.shared.getWorkNoteCount() > 0 {
              showTableController(.work)
        }else{
           // performSegue(withIdentifier: "addNotes", sender: nil)
            //when there are no notes available in table list when u click on any tag in dahsboard it will take you to add notes by defaitl tag u clicked to write notes.
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "WriteNewNotes") as! addNotesViewController
            nextViewController.isNewNote = true
            nextViewController.notesFromDashboard = true
            nextViewController.tagTypeInSelectedNotes = NoteType(rawValue: "work")
            nextViewController.isdefault = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
     
    }
  
    @IBAction func addTemporaryButtonClicked(){
        if NoteManager.shared.getTempNoteCount() > 0{
            showTableController(.temporary)
        }
        else{
             //performSegue(withIdentifier: "addNotes", sender: nil)
            //when there are no notes available in table list when u click on any tag in dahsboard it will take you to add notes by defaitl tag u clicked to write notes.
            let nextViewController = storyboard?.instantiateViewController(withIdentifier: "WriteNewNotes") as! addNotesViewController
            nextViewController.isNewNote = true
            nextViewController.notesFromDashboard = true
            nextViewController.tagTypeInSelectedNotes = NoteType(rawValue: "temporary")
            nextViewController.isdefault = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    
    @IBAction func addImportantButtonClicked(){
        if NoteManager.shared.getImpNoteCount() > 0{
              showTableController(.important)
        }else{
            //performSegue(withIdentifier: "addNotes", sender: nil)
            //when there are no notes available in table list when u click on any tag in dahsboard it will take you to add notes by defaitl tag u clicked to write notes.
               let nextViewController = storyboard?.instantiateViewController(withIdentifier: "WriteNewNotes") as! addNotesViewController
               nextViewController.isNewNote = true
               nextViewController.notesFromDashboard = true
               nextViewController.tagTypeInSelectedNotes = NoteType(rawValue: "important")
               nextViewController.isdefault = false
               self.navigationController?.pushViewController(nextViewController, animated: true)
        }
       
    }
    
    func showTableController(_ tag : NoteType){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TableViewController") as! NoteListInTableViewController
        nextViewController.tagColor = getColorForTag(tag)
        nextViewController.tagType = tag
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func getColorForTag(_ tag : NoteType) -> UIColor?{
        switch tag {
        case .temporary:
                 return temporaryView.backgroundColor
        case .important:
            return importantView.backgroundColor
        case .work:
            return workView.backgroundColor
        case .personal :
            return personalView.backgroundColor
        }
    }
    
    

   

}
